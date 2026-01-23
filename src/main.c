#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include "../inc/uart.h"
#include "../inc/rtos.h"
#include "shell.h"

void task_high(void) {
    while(1) {
        uart_print("HIGH running\n");
        for(volatile int i=0; i<30000; i++); 
        uart_print("HIGH sleeping\n");
        rtos_sleep(2000);
        uart_print("HIGH awake\n");
    }
}

void task_low(void) {
    while(1) {
        uart_print("LOW running\n");
        for(volatile int i=0; i<10000; i++);
    }
}

void task_idle_monitor(void) {
    while(1) {
       rtos_sleep(500);
    }
}

int main(void) {
    uart_init(57600);
    _delay_ms(1000);
    uart_print("\n\n==== REAL TIME OPERATING SYSTEM: WELCOME!\n");

    rtos_init();

    rtos_create_task(shell_task, 3, "Shell");
    // rtos_create_task(task_high, 1, "Task_low");

    // uart_print("Starting Scheduler...\n");
    rtos_start();

    return 0;
}
