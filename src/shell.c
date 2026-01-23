#include <string.h>
#include <stdio.h>
#include "shell.h"
#include "uart.h"
#include "rtos.h"

#define CMD_BUFFER_SIZE 32

// Helper to print a number (avoid printf overhead)
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

// Get task state as string
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

// Command: help
static void cmd_help(void) {
    uart_print("Available commands:\n");
    uart_print("  help        - Show this help\n");
    uart_print("  ps          - List all tasks\n");
    uart_print("  kill <id>   - Kill a task by ID\n");
}

// Command: ps - list all tasks
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

// Command: kill <id>
static void cmd_kill(const char *arg) {
    if (arg == NULL || *arg == '\0') {
        uart_print("Usage: kill <task_id>\n");
        return;
    }
    
    // Simple atoi
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
    
    // Don't let user kill the shell or idle task
    if (id == 0) {
        uart_print("Cannot kill idle task\n");
        return;
    }
    
    rtos_delete_task(id);
    uart_print("Task ");
    print_uint8(id);
    uart_print(" killed\n");
}

// Parse and execute a command
static void shell_execute(const char *cmd) {
    // Skip leading whitespace
    while (*cmd == ' ') cmd++;
    
    // Empty command
    if (*cmd == '\0') return;
    
    // Find command end and argument start
    const char *arg = cmd;
    while (*arg && *arg != ' ') arg++;
    uint8_t cmd_len = arg - cmd;
    while (*arg == ' ') arg++;
    
    // Match commands
    if (strncmp(cmd, "help", cmd_len) == 0 && cmd_len == 4) {
        cmd_help();
    } else if (strncmp(cmd, "ps", cmd_len) == 0 && cmd_len == 2) {
        cmd_ps();
    } else if (strncmp(cmd, "kill", cmd_len) == 0 && cmd_len == 4) {
        cmd_kill(arg);
    } else {
        uart_print("Unknown command: ");
        // Print just the command part
        for (uint8_t i = 0; i < cmd_len; i++) {
            uart_putc(cmd[i]);
        }
        uart_print("\nType 'help' for available commands\n");
    }
}

// Main shell task
void shell_task(void) {
    char cmd_buffer[CMD_BUFFER_SIZE];

    while (1) {
        uart_print("> ");
        
        // Block until we get a complete line
        uart_getline(cmd_buffer, CMD_BUFFER_SIZE);
        
        // Echo newline
        uart_print("\n");
        
        // Execute the command
        shell_execute(cmd_buffer);
    }
}
