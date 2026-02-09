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

typedef struct {
    uint8_t data[4];       // 4-byte payload (max)
    Semaphore has_data;    // blocks receivers when empty
    Semaphore has_space;   // blocks senders when full
} Mailbox;

void rtos_sem_init(Semaphore *sem, int8_t max_count, int8_t initial_count);
void rtos_sem_take(Semaphore *sem);
uint8_t rtos_sem_try_take(Semaphore *sem);
void rtos_sem_give(Semaphore *sem);
void rtos_yield(void);
void rtos_suicide(void);

void rtos_mailbox_init(Mailbox *mb);
void rtos_mailbox_send(Mailbox *mb, void *data, uint8_t size);
void rtos_mailbox_receive(Mailbox *mb, void *data, uint8_t size);
uint8_t rtos_mailbox_try_send(Mailbox *mb, void *data, uint8_t size);
uint8_t rtos_mailbox_try_receive(Mailbox *mb, void *data, uint8_t size);

void rtos_wait_tasks(uint8_t count, int8_t *task_ids);

typedef struct {
    uint8_t *sp;
    uint8_t *stack_limit;           // Lowest valid stack address (for overflow detection)
    volatile uint16_t delay_ticks;
    char name[16];
    uint16_t id;
    uint8_t priority;
    TaskState state;
    Semaphore *blocked_on;
    int8_t *waiting_for_ids;        // Pointer to array of task IDs we're waiting on
    uint8_t waiting_for_count;      // Number of IDs in the array
} TCB;

TCB tasks[MAX_TASKS];

#endif // RTOS_H
