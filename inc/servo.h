#ifndef SERVO_H
#define SERVO_H

#include <stdint.h>

void servo_init(void);
void servo_set(uint8_t angle);

#endif // SERVO_H
