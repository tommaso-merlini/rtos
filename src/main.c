#include <avr/io.h>
#include <avr/interrupt.h>
#include <stdint.h>
#include <util/delay.h>
#include "../inc/uart.h"
#include "../inc/rtos.h"
#include "../inc/servo.h"

#define LED PB5 

#ifndef F_CPU
#define F_CPU 16000000UL
#endif

uint8_t count = 0;
Semaphore mutex;

void print_num(uint8_t num) {
    if (num == 0) {
        uart_putc('0');
        return;
    }
    char buffer[4];
    int i = 0;
    while (num > 0) {
        buffer[i++] = (num % 10) + '0';
        num /= 10;
    }
    while (i > 0) {
        uart_putc(buffer[--i]);
    }
}

void task1(void) {
    while(1) {
        rtos_sem_take(&mutex);
        count++;
        uart_print("Task1: ");
        print_num(count);
        uart_print("\n");
        rtos_sem_give(&mutex);
        rtos_sleep(500);
    }
}

void task2(void) {
    // Initial delay to phase with task1 so we don't underflow (0 - 2)
    rtos_sleep(1000); 
    while(1) {
        rtos_sem_take(&mutex);
        count -= 2;
        uart_print("Task2: ");
        print_num(count);
        uart_print("\n");
        rtos_sem_give(&mutex);
        rtos_sleep(1000);
    }
}

void servo_task(void) {
    uart_print("SERVO STARTING\n");
    int16_t angle = 0;
    int16_t step = 1;
    uint8_t loop_count = 0;
    
    while(1) {
        servo_set((uint8_t)angle);

        if (loop_count++ >= 10) {
            rtos_sem_take(&mutex);
            uart_print("Servo Angle: ");
            print_num((uint8_t)angle);
            uart_print("\n");
            rtos_sem_give(&mutex);
            loop_count = 0;
        }
        
        angle += step;
        if (angle >= 180) {
            angle = 180;
            step = -1;
        } else if (angle <= 0) {
            angle = 0;
            step = 1;
        }
        
        rtos_sleep(10);
    }
}

int main(void) {
    DDRB |= (1 << LED); // led init

    uart_init(57600);
    _delay_ms(4000);
    uart_print("System Booting...\n");

    rtos_init();
    servo_init();
    rtos_sem_init(&mutex, 1, 1);
    
    rtos_create_task(task1, 1, "task 1");
    rtos_create_task(task2, 1, "task 2");
    rtos_create_task(servo_task, 1, "servo");
    
    uart_print("Starting RTOS...\n");

    rtos_start();

    //WARNING: unreachable
    while(1);
    return 0;
}
