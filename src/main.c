#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include "../inc/uart.h"
#include "../inc/rtos.h"
#include "shell.h"
#include "servo.h"

void task_high(void) {
    while(1) {
        for(volatile int i=0; i<30000; i++); 
        rtos_sleep(2000);
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
    servo_init();
    _delay_ms(100);
    uart_print("==== REAL TIME OPERATING SYSTEM: WELCOME!\n");

    rtos_init();
    rtos_create_task(task_high, 1, "Task_High");
    rtos_create_task(shell_task, 3, "Shell");
    rtos_start();

    //TODO: create tasks after start

    return 0;
}
