#include <string.h>
#include <stdio.h>
#include "shell.h"
#include "uart.h"
#include "rtos.h"
#include "servo.h"

#define CMD_BUFFER_SIZE 32

static void print_uint8(uint8_t n) {
    char buf[4];
    uint8_t i = 0;
    
    if (n == 0) {
        uart_putc('0');
        return;
    }
    
    while (n > 0) {
        buf[i++] = '0' + (n % 10);
        n /= 10;
    }
    
    while (i > 0) {
        uart_putc(buf[--i]);
    }
}

static const char* state_to_str(TaskState state) {
    switch (state) {
        case TASK_EMPTY:    return "EMPTY";
        case TASK_READY:    return "READY";
        case TASK_SLEEPING: return "SLEEP";
        case TASK_BLOCKED:  return "BLOCK";
        case TASK_DELETED:  return "DELET";
        default:            return "?????";
    }
}

static void cmd_help(void) {
    uart_print("Available commands:\n");
    uart_print("  help        - Show this help\n");
    uart_print("  ps          - List all tasks\n");
    uart_print("  kill <id>   - Kill a task by ID\n");
    uart_print("  servo <deg> - Set servo angle (0-180)\n");
    uart_print("  overflow    - Test stack overflow detection\n");
    uart_print("  mbtest      - Run mailbox tests\n");
}

static void cmd_ps(void) {
    uart_print("ID  PRI  STATE  NAME\n");
    uart_print("----------------------\n");
    
    for (uint8_t i = 0; i < MAX_TASKS; i++) {
        if (tasks[i].state != TASK_EMPTY && tasks[i].state != TASK_DELETED) {
            print_uint8(i);
            uart_print("   ");
            print_uint8(tasks[i].priority);
            uart_print("    ");
            uart_print(state_to_str(tasks[i].state));
            uart_print("  ");
            uart_print(tasks[i].name);
            uart_print("\n");
        }
    }
}

static void cmd_kill(const char *arg) {
    if (arg == NULL || *arg == '\0') {
        uart_print("Usage: kill <task_id>\n");
        return;
    }
    
    uint8_t id = 0;
    while (*arg >= '0' && *arg <= '9') {
        id = id * 10 + (*arg - '0');
        arg++;
    }
    
    if (id >= MAX_TASKS) {
        uart_print("Invalid task ID\n");
        return;
    }
    
    if (tasks[id].state == TASK_EMPTY || tasks[id].state == TASK_DELETED) {
        uart_print("Task not running\n");
        return;
    }
    
    if (id == 0) {
        uart_print("Cannot kill idle task\n");
        return;
    }
    
    rtos_delete_task(id);
    uart_print("Task ");
    print_uint8(id);
    uart_print(" killed\n");
}

// Test task that deliberately overflows its stack (128 bytes)
static void overflow_test_task(void) {
    volatile uint8_t big[200];  // Way more than STACK_SIZE
    for (int i = 0; i < 200; i++) {     
        big[i] = (uint8_t)i;
    }            
    while (1) {
        rtos_sleep(1000);
    } 
}

static void cmd_overflow(void) {
    uart_print("Spawning overflow task...\n");
    rtos_create_task(overflow_test_task, 5, "OverflowTest");
}

// ============== Mailbox Test Infrastructure ==============

static Mailbox test_mb;
static volatile uint8_t mb_test_done;
static volatile uint8_t mb_received_sum;

static void print_test_result(const char *name, uint8_t passed) {
    uart_print("[MBTEST] ");
    uart_print(name);
    uart_print(": ");
    uart_print(passed ? "PASS" : "FAIL");
    uart_print("\n");
}

// Test 1: try_receive on empty mailbox should return 0
static uint8_t test_try_empty(void) {
    rtos_mailbox_init(&test_mb);
    uint8_t dummy;
    uint8_t result = rtos_mailbox_try_receive(&test_mb, &dummy, 1);
    return (result == 0);
}

// Test 2: try_send when full should return 0
static uint8_t test_try_full(void) {
    rtos_mailbox_init(&test_mb);
    uint8_t val = 42;
    rtos_mailbox_try_send(&test_mb, &val, 1);
    uint8_t result = rtos_mailbox_try_send(&test_mb, &val, 1);
    return (result == 0);
}

// Test 3: Basic send then receive
static uint8_t test_basic_send_recv(void) {
    rtos_mailbox_init(&test_mb);
    uint8_t send_val = 0xAB;
    uint8_t recv_val = 0;
    rtos_mailbox_send(&test_mb, &send_val, 1);
    rtos_mailbox_receive(&test_mb, &recv_val, 1);
    return (recv_val == send_val);
}

// Producer task for blocking test
static void blocking_producer_task(void) {
    for (uint8_t i = 1; i <= 5; i++) {
        rtos_mailbox_send(&test_mb, &i, 1);
        rtos_sleep(10);
    }
}

// Consumer task for blocking test
static void blocking_consumer_task(void) {
    uint8_t val;
    mb_received_sum = 0;
    for (uint8_t i = 0; i < 5; i++) {
        rtos_mailbox_receive(&test_mb, &val, 1);
        mb_received_sum += val;
    }
    mb_test_done = 1;
}

// Test 4: Blocking producer/consumer
static uint8_t test_blocking(void) {
    rtos_mailbox_init(&test_mb);
    mb_test_done = 0;
    mb_received_sum = 0;
    
    rtos_create_task(blocking_consumer_task, 4, "MBConsumer");
    rtos_create_task(blocking_producer_task, 4, "MBProducer");
    
    //TODO: this should not be polled, implement timed semaphores or tasks join
    for (uint8_t i = 0; i < 200 && !mb_test_done; i++) {
        rtos_sleep(10);
    }
    
    return (mb_test_done && mb_received_sum == 15);
}

static void cmd_mbtest(void) {
    uint8_t passed = 0;
    uint8_t total = 4;
    
    uart_print("[MBTEST] Starting mailbox tests...\n");
    
    if (test_try_empty()) { passed++; print_test_result("try_empty", 1); }
    else { print_test_result("try_empty", 0); }
    
    if (test_try_full()) { passed++; print_test_result("try_full", 1); }
    else { print_test_result("try_full", 0); }
    
    if (test_basic_send_recv()) { passed++; print_test_result("basic_send_recv", 1); }
    else { print_test_result("basic_send_recv", 0); }
    
    if (test_blocking()) { passed++; print_test_result("blocking", 1); }
    else { print_test_result("blocking", 0); }
    
    //NOTE: Skipped stress, contention (too heavy for RAM)
    
    uart_print("[MBTEST] ");
    print_uint8(passed);
    uart_print("/");
    print_uint8(total);
    uart_print(" tests passed\n");
    
    if (passed == total) {
        uart_print("[MBTEST] All tests passed\n");
    }
}


static void cmd_servo(const char *arg) {
    if (arg == NULL || *arg == '\0') {
        uart_print("Usage: servo <angle 0-180>\n");
        return;
    }
    
    uint8_t angle = 0;
    while (*arg >= '0' && *arg <= '9') {
        angle = angle * 10 + (*arg - '0');
        arg++;
    }
    
    if (angle > 180) {
        uart_print("Angle must be 0-180\n");
        return;
    }
    
    servo_set(angle);
    uart_print("Servo set to ");
    print_uint8(angle);
    uart_print(" degrees\n");
}

static void shell_execute(const char *cmd) {
    while (*cmd == ' ') cmd++;
    if (*cmd == '\0') return;
    
    const char *arg = cmd;
    while (*arg && *arg != ' ') arg++;
    uint8_t cmd_len = arg - cmd;
    while (*arg == ' ') arg++;
    
    if (strncmp(cmd, "help", cmd_len) == 0 && cmd_len == 4) {
        cmd_help();
    } else if (strncmp(cmd, "ps", cmd_len) == 0 && cmd_len == 2) {
        cmd_ps();
    } else if (strncmp(cmd, "kill", cmd_len) == 0 && cmd_len == 4) {
        cmd_kill(arg);
    } else if (strncmp(cmd, "servo", cmd_len) == 0 && cmd_len == 5) {
        cmd_servo(arg);
    } else if (strncmp(cmd, "overflow", cmd_len) == 0 && cmd_len == 8) {
        cmd_overflow();
    } else if (strncmp(cmd, "mbtest", cmd_len) == 0 && cmd_len == 6) {
        cmd_mbtest();
    } else {
        uart_print("Unknown command: ");
        for (uint8_t i = 0; i < cmd_len; i++) {
            uart_putc(cmd[i]);
        }
        uart_print("\nType 'help' for available commands\n");
    }
}

void shell_task(void) {
    char cmd_buffer[CMD_BUFFER_SIZE];

    while (1) {
        uart_print("> ");
        uart_getline(cmd_buffer, CMD_BUFFER_SIZE);
        uart_print("\n");
        shell_execute(cmd_buffer);
    }
}
