#!/usr/bin/env python3
"""
Hardware-in-the-loop test script for the servo shell command.

This script sends commands over UART to the MCU and verifies the responses
match expected output.

Usage:
    python test_servo.py [--port PORT] [--baud BAUD]

Requirements:
    - pyserial
    - MCU connected and running the RTOS firmware
"""

import serial
import time
import argparse
import sys

# Default configuration (matches Makefile and uart_client.py)
DEFAULT_PORT = '/dev/ttyUSB0'
DEFAULT_BAUD = 57600
RESPONSE_TIMEOUT = 2.0  # seconds to wait for response
SERVO_SETTLE_TIME = 1.0  # seconds between tests for servo to physically move
PROMPT = '> '


class ServoTest:
    def __init__(self, port, baud):
        self.port = port
        self.baud = baud
        self.ser = None
        self.passed = 0
        self.failed = 0

    def connect(self):
        """Establish serial connection to MCU."""
        try:
            self.ser = serial.Serial(self.port, self.baud, timeout=0.1)
            print(f"Connected to {self.port} at {self.baud} baud")
            return True
        except serial.SerialException as e:
            print(f"Error connecting to serial port: {e}")
            return False

    def disconnect(self):
        """Close serial connection."""
        if self.ser:
            self.ser.close()

    def read_until_prompt(self, timeout=RESPONSE_TIMEOUT):
        """Read data until we see the shell prompt '> '."""
        buffer = ""
        end_time = time.time() + timeout
        while time.time() < end_time:
            if self.ser.in_waiting > 0:
                chunk = self.ser.read(self.ser.in_waiting).decode('utf-8', errors='ignore')
                buffer += chunk
                # Check if we have the prompt at the end
                if buffer.rstrip().endswith('>') or PROMPT in buffer:
                    # Give a tiny bit more time for any trailing data
                    time.sleep(0.05)
                    if self.ser.in_waiting > 0:
                        buffer += self.ser.read(self.ser.in_waiting).decode('utf-8', errors='ignore')
                    break
            time.sleep(0.01)
        return buffer

    def wait_for_prompt(self, timeout=5.0):
        """Wait for the shell to be ready by looking for the prompt."""
        print("Waiting for shell prompt...", end=" ", flush=True)
        buffer = ""
        end_time = time.time() + timeout
        while time.time() < end_time:
            if self.ser.in_waiting > 0:
                chunk = self.ser.read(self.ser.in_waiting).decode('utf-8', errors='ignore')
                buffer += chunk
                if PROMPT in buffer or buffer.rstrip().endswith('>'):
                    print("OK")
                    return True
            time.sleep(0.05)
        print("TIMEOUT")
        print(f"  Buffer contents: {repr(buffer)}")
        return False

    def send_command(self, cmd):
        """Send a command and capture the response."""
        # Clear any pending input
        self.ser.reset_input_buffer()
        
        # Send command with carriage return (MCU accepts \r or \n)
        self.ser.write(f"{cmd}\r".encode('utf-8'))
        
        # Read response until next prompt
        response = self.read_until_prompt()
        
        return response

    def check_response(self, response, expected):
        """Check if expected string is in the response."""
        return expected in response

    def run_test(self, name, cmd, expected, description=""):
        """Run a single test case."""
        response = self.send_command(cmd)
        
        # Let servo physically move and settle
        time.sleep(SERVO_SETTLE_TIME)
        
        passed = self.check_response(response, expected)
        
        if passed:
            self.passed += 1
            status = "[PASS]"
        else:
            self.failed += 1
            status = "[FAIL]"
        
        desc = f" - {description}" if description else ""
        print(f"{status} {name}{desc}")
        
        if not passed:
            print(f"       Expected: '{expected}'")
            # Clean up response for display
            response_clean = response.replace('\r\n', '\\r\\n').replace('\r', '\\r').replace('\n', '\\n')
            print(f"       Got: '{response_clean}'")
        
        return passed

    def run_all_tests(self):
        time.sleep(10)
        """Run all servo command tests."""
        print()
        print("=" * 50)
        print("Servo Shell Command Tests")
        print("=" * 50)
        print()

        # Wait for shell to be ready
        if not self.wait_for_prompt():
            print("ERROR: Shell not responding. Is the MCU running?")
            return False

        print()

        # Test 1: Valid minimum angle (0 degrees)
        self.run_test(
            "servo 0",
            "servo 0",
            "Servo set to 0 degrees",
            "Valid minimum angle"
        )

        # Test 2: Valid mid-range angle (90 degrees)
        self.run_test(
            "servo 90",
            "servo 90",
            "Servo set to 90 degrees",
            "Valid mid-range angle"
        )

        # Test 3: Valid maximum angle (180 degrees)
        self.run_test(
            "servo 180",
            "servo 180",
            "Servo set to 180 degrees",
            "Valid maximum angle"
        )

        # Test 4: Arbitrary valid angle
        self.run_test(
            "servo 45",
            "servo 45",
            "Servo set to 45 degrees",
            "Valid arbitrary angle"
        )

        # Test 5: Missing argument
        self.run_test(
            "servo (no arg)",
            "servo",
            "Usage: servo <angle 0-180>",
            "Usage message displayed"
        )

        # Test 6: Out-of-range angle (181)
        self.run_test(
            "servo 181",
            "servo 181",
            "Angle must be 0-180",
            "Out-of-range error"
        )

        # Test 7: Out-of-range angle (200)
        self.run_test(
            "servo 200",
            "servo 200",
            "Angle must be 0-180",
            "Large out-of-range error"
        )

        # Test 8: Non-numeric input (parsed as 0 due to atoi-like behavior)
        self.run_test(
            "servo abc",
            "servo abc",
            "Servo set to 0 degrees",
            "Non-numeric parses as 0"
        )

        # Test 9: Mixed input (number followed by text)
        self.run_test(
            "servo 45deg",
            "servo 45deg",
            "Servo set to 45 degrees",
            "Trailing text ignored"
        )

        # Test 10: Help command shows servo
        self.run_test(
            "help",
            "help",
            "servo <deg>",
            "Help shows servo command"
        )

        # Print summary
        print()
        print("-" * 50)
        total = self.passed + self.failed
        print(f"{self.passed}/{total} tests passed")
        
        if self.failed > 0:
            print(f"{self.failed} test(s) FAILED")
            return False
        else:
            print("All tests passed!")
            return True


def main():
    parser = argparse.ArgumentParser(
        description="Hardware-in-the-loop test script for servo shell command"
    )
    parser.add_argument(
        '--port', '-p',
        default=DEFAULT_PORT,
        help=f"Serial port (default: {DEFAULT_PORT})"
    )
    parser.add_argument(
        '--baud', '-b',
        type=int,
        default=DEFAULT_BAUD,
        help=f"Baud rate (default: {DEFAULT_BAUD})"
    )
    args = parser.parse_args()

    tester = ServoTest(args.port, args.baud)
    
    if not tester.connect():
        sys.exit(1)

    try:
        success = tester.run_all_tests()
        sys.exit(0 if success else 1)
    finally:
        tester.disconnect()


if __name__ == "__main__":
    main()
