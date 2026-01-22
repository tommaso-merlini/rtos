#ifndef RTOS_CONFIG_H
#define RTOS_CONFIG_H

// RTOS configuration
// Note: ATmega328P has only 2KB RAM, be careful with these values
#define MAX_TASKS 6
#define STACK_SIZE 128 
#define CONTEXT_SWITCH_MS 10000

#endif // RTOS_CONFIG_H
