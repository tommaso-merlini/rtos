#ifndef SERVO_H
#define SERVO_H

#include <stdint.h>

/**
 * @brief Initialize Timer1 for Servo PWM control (50Hz)
 * Configures PB1 (OC1A) as output.
 */
void servo_init(void);

/**
 * @brief Set the servo angle
 * @param angle Angle in degrees (0-180)
 */
void servo_set(uint8_t angle);

#endif // SERVO_H
