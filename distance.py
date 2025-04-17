import paho.mqtt.client as mqtt
import json

# ========== MQTT CONFIGURATION ==========
broker = "3.83.48.230"
port = 1883
threshold = 20  # Distance threshold in cm

def on_message(client, userdata, msg):
    try:
        data = json.loads(msg.payload.decode())
        print(f"[A] Received from B:", data)

        if "distance" in data:
            distance = data["distance"]
            print(f"[A] Distance: {distance} cm")

            # Decide whether to turn motor on
            if distance < threshold:
                response = {"motor": "on"}
                print("?? Respond: motor ON")
            else:
                response = {"motor": "off"}
                print("?? Respond: motor OFF")

            # Publish the response back to B
            client.publish("NickPart", json.dumps(response))

    except Exception as e:
        print("[A] JSON parse error:", e)

# ========== MQTT SETUP ==========
client = mqtt.Client("DeviceA")
client.on_message = on_message

client.connect(broker, port)
client.subscribe("XinyangPart")
client.loop_forever()
