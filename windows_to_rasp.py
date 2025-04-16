import json
import time
import paho.mqtt.client as mqtt
from paho.mqtt.client import CallbackAPIVersion

# MQTT broker config
BROKER = "3.83.48.230"
PORT = 1883
TOPIC_SUB = "deviceB/to/deviceA"
TOPIC_PUB = "deviceA/to/deviceB"

# Callback when message is received
def on_message(client, userdata, msg):
    try:
        payload = json.loads(msg.payload.decode())
        print(f"[Device A] Received JSON from B: {payload}")
    except Exception as e:
        print(f"[Device A] Failed to decode JSON: {e}")

# Create MQTT client with correct version
client = mqtt.Client(client_id="DeviceA")

client.on_message = on_message
client.connect(BROKER, PORT)
client.subscribe(TOPIC_SUB)
client.loop_start()

try:
    while True:
        # Create JSON message
        data = {
            "from": "DeviceA",
            "temperature": 22.5,
            "status": "running"
        }

        # Publish to Device B
        client.publish(TOPIC_PUB, json.dumps(data))
        print(f"[Device A] Sent JSON to B: {data}")
        time.sleep(5)

except KeyboardInterrupt:
    print("Interrupted by user.")
    client.loop_stop()
    client.disconnect()
