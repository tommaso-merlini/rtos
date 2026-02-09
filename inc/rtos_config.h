#ifndef RTOS_CONFIG_H
#define RTOS_CONFIG_H

// RTOS configuration
// Note: ATmega328P has only 2KB RAM, be careful with these values
#define MAX_TASKS 4
#define STACK_SIZE 384 
#define CONTEXT_SWITCH_MS 10000
#define MS_PER_TICK 1  // Timer0: 16MHz / 64 / 250 = 1000Hz = 1ms per tick

#endif // RTOS_CONFIG_H
