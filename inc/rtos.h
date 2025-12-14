#ifndef RTOS_H
#define RTOS_H

#include <stdint.h>
#include "rtos_config.h"

void rtos_init(void);
int8_t rtos_create_task(void (*task_func)(void), uint8_t priority, char name[16]);
void rtos_delete_task(uint8_t id);
void rtos_sleep(uint16_t ms);
void rtos_enter_critical(void);
void rtos_exit_critical(void);
void rtos_start(void);

typedef enum {
    TASK_EMPTY = 0,
    TASK_READY,
    TASK_SLEEPING,
    TASK_BLOCKED,
    TASK_DELETED
} TaskState;

typedef struct {
    volatile int8_t count;
    int8_t max_count;
} Semaphore;

void rtos_sem_init(Semaphore *sem, int8_t max_count, int8_t initial_count);
void rtos_sem_take(Semaphore *sem);
void rtos_sem_give(Semaphore *sem);
void rtos_yield(void);

typedef struct {
    uint8_t *sp;
    volatile uint16_t delay_ticks;
    char name[16];
    uint16_t id;
    TaskState state;
    Semaphore *blocked_on;
} TCB;
TCB tasks[MAX_TASKS];

#endif // RTOS_H
