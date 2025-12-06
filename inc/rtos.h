#ifndef RTOS_H
#define RTOS_H

#include <stdint.h>
#include "rtos_config.h"

// Initialize the RTOS structures
void rtos_init(void);

// Create a task with a given function and priority (priority not used in RR)
void rtos_create_task(void (*task_func)(void), uint8_t priority);

// Sleep for a specific number of ticks (ms)
void rtos_sleep(uint16_t ms);

// Critical Section Management
void rtos_enter_critical(void);
void rtos_exit_critical(void);

// Start the RTOS scheduler (this function generally does not return)
void rtos_start(void);

#endif // RTOS_H
