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
#define I2C_SDA_PIN 8
#define I2C_SCL_PIN 9
#define SPO2_BUFFER_SIZE 40
#define BATTERY_ADC_PIN -1

const char *DEVICE_ID = "SSTU234IX";
const char *FIRMWARE_VERSION = "1.1.0";

const char *WIFI_SSID = "CHANGE_ME";
const char *WIFI_PASSWORD = "CHANGE_ME";

const char *MQTT_HOST = "8e81645ecec344ecb81e049f54d241db.s1.eu.hivemq.cloud";
const uint16_t MQTT_PORT = 8883;
const char *MQTT_USER = "CHANGE_ME";
const char *MQTT_PASSWORD = "CHANGE_ME";

const unsigned long TELEMETRY_INTERVAL_MS = 5000;
const unsigned long STATUS_INTERVAL_MS = 30000;
const unsigned long SPO2_INTERVAL_MS = 15000;

const float GRAVITY = 9.81;
const float HIGH_TEMP_THRESHOLD = 39.0;
const float LOW_TEMP_THRESHOLD = 35.0;
const int HIGH_HEART_RATE_THRESHOLD = 120;
const int LOW_HEART_RATE_THRESHOLD = 50;

const byte RATE_SIZE = 10;
byte rates[RATE_SIZE];
byte rateSpot = 0;
long lastBeat = 0;
float beatsPerMinute = 0;
int beatAvg = 0;

uint32_t irBuffer[SPO2_BUFFER_SIZE];
uint32_t redBuffer[SPO2_BUFFER_SIZE];
int32_t spo2Value = -1;
int8_t validSPO2 = 0;
int32_t spo2HeartRate = 0;
int8_t validSpo2HeartRate = 0;

float axValue = 0;
float ayValue = 0;
float azValue = 0;
float accelerationTotal = 0;
int steps = 0;
bool stepDetected = false;
unsigned long lastStepTime = 0;
const float STEP_THRESHOLD = 12.0;
const unsigned long STEP_DELAY_MS = 100;

float temperatureValue = 0;
String tempStatus = "NORMAL";
String heartRateStatus = "NORMAL";

float axOffset = 0.131770;
float ayOffset = 0.027304;
float azOffset = 0.965072;

unsigned long lastTelemetryAt = 0;
unsigned long lastStatusAt = 0;
unsigned long lastSpo2At = 0;

WiFiClientSecure secureClient;
PubSubClient mqtt(secureClient);
OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature temperatureSensor(&oneWire);
MPU9250 mpu;
MAX30105 particleSensor;

TaskHandle_t heartRateTaskHandle;
TaskHandle_t mpuTaskHandle;
TaskHandle_t temperatureTaskHandle;
TaskHandle_t cloudTaskHandle;
TaskHandle_t wifiTaskHandle;

String telemetryTopic() {
  return "collars/" + String(DEVICE_ID) + "/telemetry";
}

String statusTopic() {
  return "collars/" + String(DEVICE_ID) + "/status";
}

void setup() {
  Wire.begin(I2C_SDA_PIN, I2C_SCL_PIN);
  Serial.begin(115200);

  setupWifi();
  setupTime();
  setupMqtt();
  setupMpu();
  setupMax30102();
  temperatureSensor.begin();

  xTaskCreate(heartRateTask, "heartRateTask", 4096, NULL, 1, &heartRateTaskHandle);
  xTaskCreate(mpuTask, "mpuTask", 4096, NULL, 1, &mpuTaskHandle);
  xTaskCreate(temperatureTask, "temperatureTask", 4096, NULL, 1, &temperatureTaskHandle);
  xTaskCreate(cloudTask, "cloudTask", 8192, NULL, 1, &cloudTaskHandle);
  xTaskCreate(wifiTask, "wifiTask", 4096, NULL, 1, &wifiTaskHandle);
}

void loop() {
  if (WiFi.status() == WL_CONNECTED) {
    if (!mqtt.connected()) reconnectMqtt();
    mqtt.loop();
  }
  delay(10);
}

void setupWifi() {
  WiFi.mode(WIFI_STA);
  WiFi.setAutoReconnect(true);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWi-Fi connected");
  Serial.print("IP: ");
  Serial.println(WiFi.localIP());
}

void setupTime() {
  configTime(3600, 0, "pool.ntp.org", "time.google.com");
}

void setupMqtt() {
  secureClient.setInsecure();
  mqtt.setServer(MQTT_HOST, MQTT_PORT);
  mqtt.setKeepAlive(30);
  mqtt.setBufferSize(1024);
  reconnectMqtt();
}

void reconnectMqtt() {
  while (WiFi.status() == WL_CONNECTED && !mqtt.connected()) {
    String clientId = "SmartCollar-" + String(DEVICE_ID);
    String willPayload = statusPayload(false);
    bool connected = strlen(MQTT_USER) > 0
                         ? mqtt.connect(
                               clientId.c_str(),
                               MQTT_USER,
                               MQTT_PASSWORD,
                               statusTopic().c_str(),
                               1,
                               true,
                               willPayload.c_str())
                         : mqtt.connect(
                               clientId.c_str(),
                               statusTopic().c_str(),
                               1,
                               true,
                               willPayload.c_str());

    if (connected) {
      Serial.println("MQTT connected");
      publishStatus(true);
    } else {
      Serial.print("MQTT failed, rc=");
      Serial.println(mqtt.state());
      delay(3000);
    }
  }
}

void publishStatus(bool isOnline) {
  String payload = statusPayload(isOnline);
  mqtt.publish(statusTopic().c_str(), payload.c_str(), true);
}

String statusPayload(bool isOnline) {
  StaticJsonDocument<320> doc;
  doc["device_id"] = DEVICE_ID;
  doc["is_online"] = isOnline;
  doc["battery_pct"] = batteryPercent();
  doc["wifi_rssi"] = WiFi.RSSI();
  doc["firmware"] = FIRMWARE_VERSION;
  doc["ts"] = currentUnixTime();

  String payload;
  serializeJson(doc, payload);
  return payload;
}

void publishTelemetry() {
  StaticJsonDocument<896> doc;
  doc["device_id"] = DEVICE_ID;
  doc["temp_c"] = validTemperature() ? temperatureValue : 0;
  doc["heart_rate_bpm"] = beatAvg;
  doc["spo2_pct"] = validSPO2 ? spo2Value : -1;
  doc["accel_x"] = axValue;
  doc["accel_y"] = ayValue;
  doc["accel_z"] = azValue;
  doc["activity_index"] = activityIndex();
  doc["mcu_temp_c"] = 0;
  doc["behavior"] = behaviorLabel();
  doc["ppr_risk_score"] = pprRiskScore();
  doc["is_anomaly"] = pprRiskScore() >= 60;
  doc["battery_pct"] = batteryPercent();
  doc["wifi_rssi"] = WiFi.RSSI();
  doc["firmware"] = FIRMWARE_VERSION;
  doc["ts"] = currentUnixTime();

  doc["high_temp"] = tempStatus == "HIGH_TEMP";
  doc["low_temp"] = tempStatus == "LOW_TEMP";
  doc["high_heart_rate"] = heartRateStatus == "HIGH_HEART_RATE";
  doc["low_heart_rate"] = heartRateStatus == "LOW_HEART_RATE";

  char payload[896];
  serializeJson(doc, payload);

  if (mqtt.publish(telemetryTopic().c_str(), payload)) {
    Serial.print("Telemetry sent: ");
    Serial.println(payload);
  } else {
    Serial.println("Telemetry publish failed");
  }
}

void heartRateTask(void *pvParameters) {
  while (1) {
    long irValue = particleSensor.getIR();
    updateHeartRate(irValue);

    if (millis() - lastSpo2At >= SPO2_INTERVAL_MS) {
      lastSpo2At = millis();
      updateSpo2();
    }

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

void cloudTask(void *pvParameters) {
  while (1) {
    if (WiFi.status() == WL_CONNECTED && mqtt.connected()) {
      if (millis() - lastTelemetryAt >= TELEMETRY_INTERVAL_MS) {
        lastTelemetryAt = millis();
        publishTelemetry();
      }

      if (millis() - lastStatusAt >= STATUS_INTERVAL_MS) {
        lastStatusAt = millis();
        publishStatus(true);
      }
    }
    vTaskDelay(pdMS_TO_TICKS(250));
  }
}

void wifiTask(void *pvParameters) {
  while (1) {
    if (WiFi.status() != WL_CONNECTED) {
      Serial.println("Wi-Fi disconnected. Reconnecting...");
      WiFi.disconnect();
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
  } else if (beatAvg > HIGH_HEART_RATE_THRESHOLD) {
    heartRateStatus = "HIGH_HEART_RATE";
  } else if (beatAvg < LOW_HEART_RATE_THRESHOLD && beatAvg > 0) {
    heartRateStatus = "LOW_HEART_RATE";
  } else {
    heartRateStatus = "NORMAL";
  }
}

void updateSpo2() {
  for (byte i = 0; i < SPO2_BUFFER_SIZE; i++) {
    unsigned long startedAt = millis();
    while (!particleSensor.available()) {
      particleSensor.check();
      if (millis() - startedAt > 500) return;
      vTaskDelay(pdMS_TO_TICKS(5));
    }

    redBuffer[i] = particleSensor.getRed();
    irBuffer[i] = particleSensor.getIR();
    particleSensor.nextSample();
  }

  maxim_heart_rate_and_oxygen_saturation(
      irBuffer,
      SPO2_BUFFER_SIZE,
      redBuffer,
      &spo2Value,
      &validSPO2,
      &spo2HeartRate,
      &validSpo2HeartRate);
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
  if (accelerationTotal > STEP_THRESHOLD && !stepDetected && currentTime - lastStepTime > STEP_DELAY_MS) {
    steps++;
    stepDetected = true;
    lastStepTime = currentTime;
  }

  if (accelerationTotal < 10.5) stepDetected = false;
}

void updateTemperature() {
  temperatureSensor.requestTemperatures();
  float tempC = temperatureSensor.getTempCByIndex(0);
  if (tempC == DEVICE_DISCONNECTED_C) {
    tempStatus = "SENSOR_ERROR";
    return;
  }

  temperatureValue = tempC;
  if (tempC > HIGH_TEMP_THRESHOLD) {
    tempStatus = "HIGH_TEMP";
  } else if (tempC < LOW_TEMP_THRESHOLD) {
    tempStatus = "LOW_TEMP";
  } else {
    tempStatus = "NORMAL";
  }
}

void setupMax30102() {
  Serial.println("Initializing MAX30102...");
  if (!particleSensor.begin(Wire, I2C_SPEED_FAST)) {
    Serial.println("MAX30102 was not found.");
    while (1) delay(1000);
  }

  particleSensor.setup();
  particleSensor.setPulseAmplitudeRed(0x0F);
  particleSensor.setPulseAmplitudeIR(0x0F);
}

void setupMpu() {
  if (!mpu.setup(0x68)) {
    Serial.println("MPU connection failed");
    delay(1000);
  } else {
    Serial.println("MPU ready");
  }
}

bool validTemperature() {
  return tempStatus != "SENSOR_ERROR";
}

int activityIndex() {
  int score = (steps * 2) + (max(0.0f, accelerationTotal - 9.8f) * 8);
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

  if (beatAvg >= HIGH_HEART_RATE_THRESHOLD || (beatAvg > 0 && beatAvg <= LOW_HEART_RATE_THRESHOLD)) {
    score += 25;
  }

  int activity = activityIndex();
  if (activity <= 10) score += 30;
  else if (activity <= 20) score += 15;

  return constrain(score, 0, 100);
}

int batteryPercent() {
#if BATTERY_ADC_PIN >= 0
  int raw = analogRead(BATTERY_ADC_PIN);
  float voltage = (raw / 4095.0) * 3.3 * 2.0;
  int pct = (int)(((voltage - 3.3) / (4.2 - 3.3)) * 100);
  return constrain(pct, 0, 100);
#else
  return -1;
#endif
}

uint32_t currentUnixTime() {
  time_t now = time(nullptr);
  if (now < 1700000000) return 0;
  return (uint32_t)now;
}
