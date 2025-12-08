import serial
import time
import threading
import sys

# Configure your serial port here
SERIAL_PORT = '/dev/ttyUSB0'  # Adjust this to your port
BAUD_RATE = 57600

try:
    ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1)
    print(f"Connected to {SERIAL_PORT} at {BAUD_RATE} baud.")
except serial.SerialException as e:
    print(f"Error connecting to serial port: {e}")
    sys.exit(1)

def read_from_serial():
    while True:
        try:
            if ser.in_waiting > 0:
                line = ser.read(ser.in_waiting).decode('utf-8', errors='ignore')
                print(line, end='', flush=True)
            else:
                time.sleep(0.01)
        except OSError:
            break

# Start the reading thread
reader_thread = threading.Thread(target=read_from_serial, daemon=True)
reader_thread.start()

print("Type something and press Enter to send to MCU. Press Ctrl+C to exit.")

try:
    while True:
        user_input = input()
        ser.write(user_input.encode('utf-8'))
        ser.write(b'\n') # Send newline as MCU expects it
except KeyboardInterrupt:
    print("\nExiting...")
finally:
    ser.close()
