#include <avr/io.h>
#include <avr/interrupt.h>
#include "../inc/servo.h"
#include "../inc/rtos.h"

// Servo configuration for 50Hz signal (20ms period)
// F_CPU = 16MHz, Prescaler = 8 => Tick = 0.5us
// Period = 20ms / 0.5us = 40000 ticks
#define SERVO_PWM_TOP       39999
#define SERVO_MIN_TICKS     1000  // 0.5ms (0 deg)
#define SERVO_MAX_TICKS     5000  // 2.5ms (180 deg)
#define SERVO_RANGE_TICKS   (SERVO_MAX_TICKS - SERVO_MIN_TICKS)

#define ANGLE_TO_TICKS(angle) (SERVO_MIN_TICKS + ((uint32_t)(angle) * SERVO_RANGE_TICKS) / 180)

void servo_init(void) {
    PRR &= ~(1 << PRTIM1);            // Enable Timer1 power
    DDRB |= (1 << PB1) | (1 << PB2);  // Set PB1 (OC1A) and PB2 (OC1B) as outputs
    TCCR1A = 0;
    TCCR1B = 0;
    TCNT1 = 0;
    TIMSK1 = 0;     // Disable interrupts
    TIFR1 = 0xFF;   // Clear pending flags
    ICR1 = SERVO_PWM_TOP;
    uint16_t initial_ticks = ANGLE_TO_TICKS(90);
    OCR1A = initial_ticks;
    OCR1B = initial_ticks;
    TCCR1A = (1 << COM1A1) | (1 << COM1B1) | (1 << WGM11);
    TCCR1B = (1 << WGM13) | (1 << WGM12) | (1 << CS11);
}

void servo_set(uint8_t angle) {
    if (angle > 180) {
        angle = 180;
    }
    uint16_t ticks = ANGLE_TO_TICKS(angle);
    rtos_enter_critical();
    OCR1A = ticks;
    OCR1B = ticks;
    rtos_exit_critical();
}
