#!/usr/bin/env python3
"""
Unified test runner for all HIL (Hardware-in-the-Loop) tests.

Runs all tests sequentially and reports a summary.
Stack overflow test runs last since it halts the MCU.

Usage:
    python run_tests.py [--port PORT] [--baud BAUD]
"""

import sys
import argparse

from test_sem_timeout import SemTimeoutTest
from test_mailbox import test_mailbox
from test_servo import ServoTest
from test_stack_overflow import test_stack_overflow

DEFAULT_PORT = '/dev/ttyUSB0'
DEFAULT_BAUD = 57600


def run_sem_timeout(port, baud):
    tester = SemTimeoutTest(port, baud)
    if not tester.connect():
        return False
    try:
        return tester.run_test()
    finally:
        tester.disconnect()


def run_servo(port, baud):
    tester = ServoTest(port, baud)
    if not tester.connect():
        return False
    try:
        return tester.run_all_tests()
    finally:
        tester.disconnect()


def main():
    parser = argparse.ArgumentParser(description="Run all HIL tests")
    parser.add_argument('--port', '-p', default=DEFAULT_PORT)
    parser.add_argument('--baud', '-b', type=int, default=DEFAULT_BAUD)
    args = parser.parse_args()

    results = {}

    tests = [
        ("sem_timeout", "Semaphore Timeout", lambda: run_sem_timeout(args.port, args.baud)),
        ("mailbox", "Mailbox", lambda: test_mailbox(args.port, args.baud) == 0),
        ("servo", "Servo", lambda: run_servo(args.port, args.baud)),
        ("stack_overflow", "Stack Overflow (DESTRUCTIVE)", lambda: test_stack_overflow(args.port, args.baud) == 0),
    ]

    for i, (key, name, runner) in enumerate(tests, 1):
        print(f"\n{'='*60}")
        print(f"TEST {i}: {name}")
        print('='*60)
        try:
            results[key] = runner()
        except Exception as e:
            print(f"ERROR: {e}")
            results[key] = False

    # Summary
    print(f"\n{'='*60}")
    print("TEST SUMMARY")
    print('='*60)

    passed = sum(1 for v in results.values() if v)
    total = len(results)

    for key, result in results.items():
        status = "[PASS]" if result else "[FAIL]"
        print(f"  {status} {key}")

    print('-'*40)
    print(f"{passed}/{total} tests passed")

    sys.exit(0 if passed == total else 1)


if __name__ == "__main__":
    main()
