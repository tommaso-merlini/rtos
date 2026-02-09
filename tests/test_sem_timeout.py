#!/usr/bin/env python3
"""
Hardware-in-the-loop test for semaphore timeout via shell command.

Usage:
    python test_sem_timeout.py [--port PORT] [--baud BAUD]
"""

import serial
import time
import argparse
import sys

DEFAULT_PORT = '/dev/ttyUSB0'
DEFAULT_BAUD = 57600
RESPONSE_TIMEOUT = 10.0
PROMPT = '> '


class SemTimeoutTest:
    def __init__(self, port, baud):
        self.port = port
        self.baud = baud
        self.ser = None

    def connect(self):
        try:
            self.ser = serial.Serial(self.port, self.baud, timeout=0.1)
            # Reset MCU
            self.ser.dtr = False
            time.sleep(0.1)
            self.ser.dtr = True
            print(f"Connected to {self.port} at {self.baud} baud")
            return True
        except serial.SerialException as e:
            print(f"Error: {e}")
            return False

    def disconnect(self):
        if self.ser:
            self.ser.close()

    def read_until_prompt(self, timeout=RESPONSE_TIMEOUT):
        buffer = ""
        end_time = time.time() + timeout
        while time.time() < end_time:
            if self.ser.in_waiting > 0:
                chunk = self.ser.read(self.ser.in_waiting).decode('utf-8', errors='ignore')
                buffer += chunk
                if PROMPT in buffer[-10:]:
                    time.sleep(0.05)
                    if self.ser.in_waiting > 0:
                        buffer += self.ser.read(self.ser.in_waiting).decode('utf-8', errors='ignore')
                    break
            time.sleep(0.01)
        return buffer

    def wait_for_prompt(self, timeout=5.0):
        print("Waiting for shell prompt...", end=" ", flush=True)
        buffer = ""
        end_time = time.time() + timeout
        while time.time() < end_time:
            if self.ser.in_waiting > 0:
                chunk = self.ser.read(self.ser.in_waiting).decode('utf-8', errors='ignore')
                buffer += chunk
                if PROMPT in buffer:
                    print("OK")
                    return True
            time.sleep(0.05)
        print("TIMEOUT")
        print(f"  Buffer: {repr(buffer)}")
        return False

    def send_command(self, cmd):
        self.ser.reset_input_buffer()
        self.ser.write(f"{cmd}\r".encode('utf-8'))
        return self.read_until_prompt()

    def run_test(self):
        print()
        print("=" * 50)
        print("Semaphore Timeout Shell Command Test")
        print("=" * 50)
        print()

        if not self.wait_for_prompt():
            print("ERROR: Shell not responding")
            return False

        print("Sending 'semtest' command...")
        print("-" * 50)

        response = self.send_command("semtest")
        print(response)
        print("-" * 50)

        # Check expected outputs
        checks = [
            ("[SEMTEST] Starting", "Test started"),
            ("timeout", "Timeout test ran"),
            ("success", "Success test ran"),
            ("2/2 tests passed", "All tests passed"),
        ]

        passed = 0
        for expected, desc in checks:
            if expected in response:
                print(f"[PASS] {desc}")
                passed += 1
            else:
                print(f"[FAIL] {desc} - expected '{expected}'")

        print()
        print("-" * 50)
        if passed == len(checks):
            print("All checks passed!")
            return True
        else:
            print(f"{passed}/{len(checks)} checks passed")
            return False


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--port', '-p', default=DEFAULT_PORT)
    parser.add_argument('--baud', '-b', type=int, default=DEFAULT_BAUD)
    args = parser.parse_args()

    tester = SemTimeoutTest(args.port, args.baud)

    if not tester.connect():
        sys.exit(1)

    try:
        success = tester.run_test()
        sys.exit(0 if success else 1)
    finally:
        tester.disconnect()


if __name__ == "__main__":
    main()
