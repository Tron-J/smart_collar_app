#include <ArduinoJson.h>
#include <DallasTemperature.h>
#include <MAX30105.h>
#include <MPU9250.h>
#include <OneWire.h>
#include <PubSubClient.h>
#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <Wire.h>
#include <heartRate.h>
#include <spo2_algorithm.h>
#include <time.h>

#define ONE_WIRE_BUS 4
#define WAT_OFFSET 1
#define BUFFER_SIZE 40

const char *DEVICE_ID = "SSTU234IX";
const char *FIRMWARE_VERSION = "1.0.0";

const char *WIFI_SSID = "CHANGE_ME";
const char *WIFI_PASSWORD = "CHANGE_ME";

const char *MQTT_HOST = "8e81645ecec344ecb81e049f54d241db.s1.eu.hivemq.cloud";
const uint16_t MQTT_PORT = 8883;
const char *MQTT_USER = "CHANGE_ME";
const char *MQTT_PASSWORD = "CHANGE_ME";

const float GRAVITY = 9.81;
const float highTempThreshold = 39.0;
const float lowTempThreshold = 35.0;
const int highHeartRateThreshold = 120;
const int lowHeartRateThreshold = 50;

WiFiClientSecure wifiClient;
PubSubClient mqtt(wifiClient);
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);
MPU9250 mpu;
MAX30105 particleSensor;

TaskHandle_t heartRateTaskHandle;
TaskHandle_t mpuTaskHandle;
TaskHandle_t temperatureTaskHandle;
TaskHandle_t telemetryTaskHandle;
TaskHandle_t wifiTaskHandle;

const byte RATE_SIZE = 10;
byte rates[RATE_SIZE];
byte rateSpot = 0;
long lastBeat = 0;
float beatsPerMinute = 0;
int beatAvg = 0;

uint32_t irBuffer[BUFFER_SIZE];
uint32_t redBuffer[BUFFER_SIZE];
int32_t spo2 = -1;
int8_t validSPO2;
int32_t heartRate;
int8_t validHeartRate;

float axValue = 0;
float ayValue = 0;
float azValue = 0;
float accelerationTotal = 0;
int steps = 0;
bool stepDetected = false;
unsigned long lastStepTime = 0;
const float stepThreshold = 12.0;
const unsigned long stepDelay = 100;

float temperatureValue = 0;
String tempStatus = "NORMAL";
String heartRateStatus = "NORMAL";

float axOffset = 0.131770;
float ayOffset = 0.027304;
float azOffset = 0.965072;

void setup() {
  Wire.begin(8, 9);
  Serial.begin(115200);

  setupWifi();
  setupMqtt();
  setupMpu();
  setupMax30102();
  sensors.begin();

  xTaskCreate(heartRateTask, "heartRateTask", 4096, NULL, 1, &heartRateTaskHandle);
  xTaskCreate(mpuTask, "mpuTask", 4096, NULL, 1, &mpuTaskHandle);
  xTaskCreate(temperatureTask, "temperatureTask", 4096, NULL, 1, &temperatureTaskHandle);
  xTaskCreate(telemetryTask, "telemetryTask", 6144, NULL, 1, &telemetryTaskHandle);
  xTaskCreate(wifiTask, "wifiTask", 4096, NULL, 1, &wifiTaskHandle);
}

void loop() {
  if (!mqtt.connected()) reconnectMqtt();
  mqtt.loop();
}

void setupWifi() {
  WiFi.mode(WIFI_STA);
  WiFi.setAutoReconnect(true);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWiFi connected");
}

void setupMqtt() {
  wifiClient.setInsecure();
  mqtt.setServer(MQTT_HOST, MQTT_PORT);
  reconnectMqtt();
}

void reconnectMqtt() {
  while (!mqtt.connected()) {
    String clientId = "JuliusCollar-" + String(DEVICE_ID);
    bool connected = strlen(MQTT_USER) > 0
                         ? mqtt.connect(clientId.c_str(), MQTT_USER, MQTT_PASSWORD)
                         : mqtt.connect(clientId.c_str());
    if (connected) {
      publishStatus(true);
    } else {
      delay(3000);
    }
  }
}

void publishStatus(bool isOnline) {
  StaticJsonDocument<256> doc;
  doc["device_id"] = DEVICE_ID;
  doc["is_online"] = isOnline;
  doc["firmware"] = FIRMWARE_VERSION;

  char payload[256];
  serializeJson(doc, payload);

  String topic = "collars/" + String(DEVICE_ID) + "/status";
  mqtt.publish(topic.c_str(), payload, true);
}

void publishTelemetry() {
  StaticJsonDocument<768> doc;
  doc["device_id"] = DEVICE_ID;
  doc["temp_c"] = temperatureValue;
  doc["heart_rate_bpm"] = beatAvg;
  doc["spo2_pct"] = validSPO2 ? spo2 : -1;
  doc["accel_x"] = axValue;
  doc["accel_y"] = ayValue;
  doc["accel_z"] = azValue;
  doc["activity_index"] = activityIndex();
  doc["mcu_temp_c"] = 0;
  doc["behavior"] = behaviorLabel();
  doc["ppr_risk_score"] = pprRiskScore();
  doc["is_anomaly"] = doc["ppr_risk_score"].as<int>() >= 60;
  doc["battery_pct"] = 100;
  doc["wifi_rssi"] = WiFi.RSSI();
  doc["firmware"] = FIRMWARE_VERSION;
  doc["ts"] = (uint32_t)time(nullptr);

  char payload[768];
  serializeJson(doc, payload);

  String topic = "collars/" + String(DEVICE_ID) + "/telemetry";
  if (mqtt.publish(topic.c_str(), payload)) {
    Serial.println(payload);
  } else {
    Serial.println("MQTT telemetry publish failed");
  }
}

int activityIndex() {
  int score = (steps * 2) + max(0.0f, accelerationTotal - 9.8f) * 8;
  return constrain(score, 0, 100);
}

const char *behaviorLabel() {
  int activity = activityIndex();
  if (activity <= 15) return "resting";
  if (activity <= 65) return "grazing";
  return "running";
}

int pprRiskScore() {
  int score = 0;
  if (temperatureValue >= 40.0) score += 45;
  else if (temperatureValue >= 39.7) score += 25;

  if (beatAvg >= highHeartRateThreshold || (beatAvg > 0 && beatAvg <= lowHeartRateThreshold)) {
    score += 25;
  }

  int activity = activityIndex();
  if (activity <= 10) score += 30;
  else if (activity <= 20) score += 15;

  return constrain(score, 0, 100);
}

void heartRateTask(void *pvParameters) {
  while (1) {
    long irValue = particleSensor.getIR();
    updateHeartRate(irValue);
    vTaskDelay(pdMS_TO_TICKS(20));
  }
}

void mpuTask(void *pvParameters) {
  while (1) {
    updateMpu();
    vTaskDelay(pdMS_TO_TICKS(50));
  }
}

void temperatureTask(void *pvParameters) {
  while (1) {
    updateTemperature();
    vTaskDelay(pdMS_TO_TICKS(1000));
  }
}

void telemetryTask(void *pvParameters) {
  while (1) {
    if (WiFi.status() == WL_CONNECTED && mqtt.connected()) {
      publishTelemetry();
    }
    vTaskDelay(pdMS_TO_TICKS(5000));
  }
}

void wifiTask(void *pvParameters) {
  while (1) {
    if (WiFi.status() != WL_CONNECTED) {
      WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    }
    vTaskDelay(pdMS_TO_TICKS(10000));
  }
}

void updateHeartRate(long irValue) {
  if (checkForBeat(irValue)) {
    long delta = millis() - lastBeat;
    lastBeat = millis();
    float newBpm = 60 / (delta / 1000.0);
    if (newBpm < 255 && newBpm > 20) {
      beatsPerMinute = (0.8 * beatsPerMinute) + (0.2 * newBpm);
      rates[rateSpot++] = (byte)beatsPerMinute;
      rateSpot %= RATE_SIZE;
      beatAvg = 0;
      for (byte x = 0; x < RATE_SIZE; x++) beatAvg += rates[x];
      beatAvg /= RATE_SIZE;
    }
  }

  if (irValue < 5000) {
    beatsPerMinute = 0;
    beatAvg = 0;
    heartRateStatus = "NO_CONTACT";
  } else if (beatAvg > highHeartRateThreshold) {
    heartRateStatus = "HIGH_HEART_RATE";
  } else if (beatAvg < lowHeartRateThreshold && beatAvg > 0) {
    heartRateStatus = "LOW_HEART_RATE";
  } else {
    heartRateStatus = "NORMAL";
  }
}

void updateMpu() {
  mpu.update();
  float axG = mpu.getAccX() - axOffset;
  float ayG = mpu.getAccY() - ayOffset;
  float azG = mpu.getAccZ() - azOffset;

  axValue = axG * GRAVITY;
  ayValue = ayG * GRAVITY;
  azValue = azG * GRAVITY;
  accelerationTotal = sqrt((axValue * axValue) + (ayValue * ayValue) + (azValue * azValue));

  unsigned long currentTime = millis();
  if (accelerationTotal > stepThreshold && !stepDetected && currentTime - lastStepTime > stepDelay) {
    steps++;
    stepDetected = true;
    lastStepTime = currentTime;
  }
  if (accelerationTotal < 10.5) stepDetected = false;
}

void updateTemperature() {
  sensors.requestTemperatures();
  float tempC = sensors.getTempCByIndex(0);
  if (tempC == DEVICE_DISCONNECTED_C) {
    tempStatus = "SENSOR_ERROR";
    return;
  }

  temperatureValue = tempC;
  if (tempC > highTempThreshold) tempStatus = "HIGH_TEMP";
  else if (tempC < lowTempThreshold) tempStatus = "LOW_TEMP";
  else tempStatus = "NORMAL";
}

void setupMax30102() {
  if (!particleSensor.begin(Wire, I2C_SPEED_FAST)) {
    Serial.println("MAX30102 was not found.");
    while (1);
  }
  particleSensor.setup();
  particleSensor.setPulseAmplitudeRed(0x0F);
  particleSensor.setPulseAmplitudeIR(0x0F);
}

void setupMpu() {
  if (!mpu.setup(0x68)) {
    Serial.println("MPU connection failed");
    delay(1000);
  }
}
