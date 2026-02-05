#!/usr/bin/env python3
"""
Hardware-in-the-loop test for mailbox messaging.

Test scenarios covered:
  1. try_empty     - try_receive on empty mailbox returns 0
  2. try_full      - try_send on full mailbox returns 0
  3. basic_send_recv - send value, receive it, verify match
  4. blocking      - producer/consumer with blocking send/receive
"""

import serial
import time
import argparse
import sys
import re

DEFAULT_PORT = '/dev/ttyUSB0'
DEFAULT_BAUD = 57600
TIMEOUT = 10.0
PROMPT = '> '


def test_mailbox(port, baud):
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

    # Send mbtest command
    print("Sending 'mbtest' command...")
    ser.write(b"mbtest\r")

    # Collect output
    buffer = ""
    end_time = time.time() + TIMEOUT

    print("Running mailbox tests...\n")
    print("-" * 50)

    while time.time() < end_time:
        if ser.in_waiting > 0:
            chunk = ser.read(ser.in_waiting).decode('utf-8', errors='ignore')
            buffer += chunk
            print(chunk, end='', flush=True)

            if "[MBTEST] All tests passed" in buffer:
                break
        time.sleep(0.01)

    print("\n" + "-" * 50)
    ser.close()

    # Parse results
    test_results = {}
    test_names = ['try_empty', 'try_full', 'basic_send_recv', 'blocking']

    for name in test_names:
        pattern = rf'\[MBTEST\] {name}: (PASS|FAIL)'
        match = re.search(pattern, buffer)
        if match:
            test_results[name] = match.group(1) == 'PASS'
        else:
            test_results[name] = None

    # Print summary
    print("\nTest Results:")
    print("-" * 30)

    passed = 0
    failed = 0
    missing = 0

    for name in test_names:
        result = test_results[name]
        if result is True:
            status = "[PASS]"
            passed += 1
        elif result is False:
            status = "[FAIL]"
            failed += 1
        else:
            status = "[????]"
            missing += 1
        print(f"  {status} {name}")

    print("-" * 30)
    print(f"Passed: {passed}, Failed: {failed}, Missing: {missing}")
    print()

    if passed == len(test_names) and failed == 0 and missing == 0:
        print("[SUCCESS] All mailbox tests passed!")
        return 0
    else:
        print("[FAILURE] Some tests failed or did not complete")
        return 1


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--port', '-p', default=DEFAULT_PORT)
    parser.add_argument('--baud', '-b', type=int, default=DEFAULT_BAUD)
    args = parser.parse_args()
    sys.exit(test_mailbox(args.port, args.baud))


if __name__ == "__main__":
    main()
