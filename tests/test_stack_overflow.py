#!/usr/bin/env python3
"""
Hardware-in-the-loop test for stack overflow detection.

This test sends the 'overflow' command which spawns a task that
deliberately exceeds its 128-byte stack. The RTOS should detect
this and print a panic message before halting.

Usage:
    python test_stack_overflow.py [--port PORT] [--baud BAUD]

Expected output:
    PANIC: Stack overflow in task: OverflowTest
"""

import serial
import time
import argparse
import sys

DEFAULT_PORT = '/dev/ttyUSB0'
DEFAULT_BAUD = 57600
TIMEOUT = 5.0  # seconds to wait for panic


def test_stack_overflow(port, baud):
    print(f"Connecting to {port} at {baud} baud...")
    
    try:
        ser = serial.Serial(port, baud, timeout=0.1)
    except serial.SerialException as e:
        print(f"Error: {e}")
        return 1
    
    # Wait for shell to be ready
    print("Waiting for shell prompt...")
    time.sleep(2.0)
    ser.reset_input_buffer()
    
    # Send overflow command
    print("Sending 'overflow' command...")
    ser.write(b"overflow\r")
    
    # Wait for panic message
    buffer = ""
    end_time = time.time() + TIMEOUT
    
    print("Waiting for panic message...\n")
    print("-" * 40)
    
    while time.time() < end_time:
        if ser.in_waiting > 0:
            chunk = ser.read(ser.in_waiting).decode('utf-8', errors='ignore')
            buffer += chunk
            print(chunk, end='', flush=True)
            
            if "PANIC: Stack overflow in task: OverflowTest" in buffer:
                print("\n" + "-" * 40)
                print("\n[PASS] Stack overflow detected correctly!")
                ser.close()
                return 0
        
        time.sleep(0.01)
    
    print("\n" + "-" * 40)
    print("\n[FAIL] Expected panic message not received within timeout")
    print(f"Buffer contents:\n{buffer}")
    ser.close()
    return 1


def main():
    parser = argparse.ArgumentParser(
        description="Test stack overflow detection"
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
    
    sys.exit(test_stack_overflow(args.port, args.baud))


if __name__ == "__main__":
    main()
