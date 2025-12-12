#include <avr/io.h>
#include <avr/interrupt.h> // For critical sections
#include "../inc/servo.h"
#include "../inc/rtos.h"   // For rtos_enter/exit_critical

// Servo configuration for 50Hz signal (20ms period)
// F_CPU = 16MHz, Prescaler = 8 => Tick = 0.5us
// Period = 20ms / 0.5us = 40000 ticks
#define SERVO_PWM_TOP       39999
#define SERVO_MIN_TICKS     2000  // 1ms (0 deg)
#define SERVO_MAX_TICKS     4000  // 2ms (180 deg)
#define SERVO_RANGE_TICKS   (SERVO_MAX_TICKS - SERVO_MIN_TICKS)

#define ANGLE_TO_TICKS(angle) (SERVO_MIN_TICKS + ((uint32_t)(angle) * SERVO_RANGE_TICKS) / 180)

void servo_init(void) {
    // 1. Power management and pin configuration
    PRR &= ~(1 << PRTIM1);            // Enable Timer1 power
    DDRB |= (1 << PB1) | (1 << PB2);  // Set PB1 (OC1A) and PB2 (OC1B) as outputs

    // 2. Reset Timer1 to safe state
    TCCR1A = 0;
    TCCR1B = 0;
    TCNT1 = 0;
    TIMSK1 = 0;     // Disable interrupts
    TIFR1 = 0xFF;   // Clear pending flags

    // 3. Configure Timer1 for Fast PWM Mode 14 (TOP = ICR1)
    ICR1 = SERVO_PWM_TOP;
    
    // Set initial position to 90 degrees
    uint16_t initial_ticks = ANGLE_TO_TICKS(90);
    OCR1A = initial_ticks;
    OCR1B = initial_ticks;

    // Configure Output Compare: Clear on Match, Set at BOTTOM (Non-inverting)
    // Mode 14: WGM13=1, WGM12=1, WGM11=1, WGM10=0
    TCCR1A = (1 << COM1A1) | (1 << COM1B1) | (1 << WGM11);
    
    // Start Timer: Prescaler = 8
    TCCR1B = (1 << WGM13) | (1 << WGM12) | (1 << CS11);
}

void servo_set(uint8_t angle) {
    if (angle > 180) {
        angle = 180;
    }

    uint16_t ticks = ANGLE_TO_TICKS(angle);

    // Critical section for atomic 16-bit register access
    rtos_enter_critical();
    OCR1A = ticks;
    OCR1B = ticks;
    rtos_exit_critical();
}
