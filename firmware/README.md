# Julius Collar Firmware

`animal_tracker_mqtt/animal_tracker_mqtt.ino` is the MQTT version of the collar firmware for the Flutter/backend stack in this repo.

## Required Arduino Libraries

- ArduinoJson
- PubSubClient
- DallasTemperature
- OneWire
- MPU9250
- SparkFun MAX3010x / MAX30105

## Configure Before Flashing

Update these constants in the sketch:

```cpp
const char *DEVICE_ID = "SSTU234IX";
const char *WIFI_SSID = "CHANGE_ME";
const char *WIFI_PASSWORD = "CHANGE_ME";
const char *MQTT_HOST = "8e81645ecec344ecb81e049f54d241db.s1.eu.hivemq.cloud";
const uint16_t MQTT_PORT = 8883;
const char *MQTT_USER = "your_hivemq_username";
const char *MQTT_PASSWORD = "your_hivemq_password";
```

The backend expects a paired collar row whose `device_id` matches `DEVICE_ID`.

## MQTT Topics

Telemetry:

```text
collars/{DEVICE_ID}/telemetry
```

Status:

```text
collars/{DEVICE_ID}/status
```

## Payload

The firmware publishes:

```json
{
  "device_id": "SSTU234IX",
  "temp_c": 39.1,
  "heart_rate_bpm": 85,
  "spo2_pct": 97,
  "accel_x": 0.1,
  "accel_y": 0.2,
  "accel_z": 9.7,
  "activity_index": 41,
  "mcu_temp_c": 31.5,
  "behavior": "grazing",
  "ppr_risk_score": 0,
  "is_anomaly": false,
  "battery_pct": 100,
  "wifi_rssi": -55,
  "firmware": "1.0.0",
  "ts": 1781130000
}
```

The backend also accepts the older Firebase-style field names from the original sketch, but MQTT is the production path for live app updates.

## Test Without Hardware

After pairing a collar with `device_id = SSTU234IX`, publish this test message to your broker:

```bash
mosquitto_pub -h 8e81645ecec344ecb81e049f54d241db.s1.eu.hivemq.cloud -p 8883 --cafile ISRG_Root_X1.pem -u YOUR_USERNAME -P YOUR_PASSWORD -t collars/SSTU234IX/telemetry -m "{\"temperature\":39.1,\"heart_rate\":85,\"spo2\":97,\"steps\":3,\"acceleration\":10.8}"
```

The backend will normalize it into the app reading format and push it to connected WebSocket clients.
