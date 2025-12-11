#include <avr/io.h>
#include <avr/interrupt.h>
#include <stdint.h>
#include <string.h>
#include "../inc/rtos.h"

//TODO: create a unified sleep function where if the sleep is >= 1ms than use the scheduler to sleep, otherwise use _delay_us

#define SAVE_CONTEXT() \
    asm volatile ( \
        "push r0 \n\t" \
        "in r0, __SREG__ \n\t" \
        "push r0 \n\t" \
        "push r1 \n\t" \
        "clr r1 \n\t" \
        "push r2 \n\t" \
        "push r3 \n\t" \
        "push r4 \n\t" \
        "push r5 \n\t" \
        "push r6 \n\t" \
        "push r7 \n\t" \
        "push r8 \n\t" \
        "push r9 \n\t" \
        "push r10 \n\t" \
        "push r11 \n\t" \
        "push r12 \n\t" \
        "push r13 \n\t" \
        "push r14 \n\t" \
        "push r15 \n\t" \
        "push r16 \n\t" \
        "push r17 \n\t" \
        "push r18 \n\t" \
        "push r19 \n\t" \
        "push r20 \n\t" \
        "push r21 \n\t" \
        "push r22 \n\t" \
        "push r23 \n\t" \
        "push r24 \n\t" \
        "push r25 \n\t" \
        "push r26 \n\t" \
        "push r27 \n\t" \
        "push r28 \n\t" \
        "push r29 \n\t" \
        "push r30 \n\t" \
        "push r31 \n\t" \
        "in r26, __SP_L__ \n\t" \
        "in r27, __SP_H__ \n\t" \
        "sts current_sp, r26 \n\t" \
        "sts current_sp+1, r27 \n\t" \
    );

#define RESTORE_CONTEXT() \
    asm volatile ( \
        "lds r26, current_sp \n\t" \
        "lds r27, current_sp+1 \n\t" \
        "out __SP_L__, r26 \n\t" \
        "out __SP_H__, r27 \n\t" \
        "pop r31 \n\t" \
        "pop r30 \n\t" \
        "pop r29 \n\t" \
        "pop r28 \n\t" \
        "pop r27 \n\t" \
        "pop r26 \n\t" \
        "pop r25 \n\t" \
        "pop r24 \n\t" \
        "pop r23 \n\t" \
        "pop r22 \n\t" \
        "pop r21 \n\t" \
        "pop r20 \n\t" \
        "pop r19 \n\t" \
        "pop r18 \n\t" \
        "pop r17 \n\t" \
        "pop r16 \n\t" \
        "pop r15 \n\t" \
        "pop r14 \n\t" \
        "pop r13 \n\t" \
        "pop r12 \n\t" \
        "pop r11 \n\t" \
        "pop r10 \n\t" \
        "pop r9 \n\t" \
        "pop r8 \n\t" \
        "pop r7 \n\t" \
        "pop r6 \n\t" \
        "pop r5 \n\t" \
        "pop r4 \n\t" \
        "pop r3 \n\t" \
        "pop r2 \n\t" \
        "pop r1 \n\t" \
        "pop r0 \n\t" \
        "out __SREG__, r0 \n\t" \
        "pop r0 \n\t" \
        "reti \n\t" \
    );

TCB tasks[MAX_TASKS];
uint8_t task_stacks[MAX_TASKS][STACK_SIZE];
volatile uint8_t task_count = 0;
volatile uint8_t current_task_index = 0;

volatile uint8_t *volatile current_sp;

void idle_task(void) {
    while(1) { }
}

void init_timer0(void) {
    TCCR0A = (1 << WGM01); // CTC mode
    TCCR0B = (1 << CS01) | (1 << CS00); // Prescaler 64
    OCR0A = 249; 
    TIMSK0 = (1 << OCIE0A); // Enable Compare Match A interrupt
}

void rtos_init(void) {
    init_timer0();
    
    task_count = 0;
    current_task_index = 0;

    rtos_create_task(idle_task, 0, "idle task");
}

//TODO: do something with priority
int8_t rtos_create_task(void (*task_func)(void), uint8_t priority, char name[16]) {
    if (task_count >= MAX_TASKS) return -1;
    
    uint8_t *stack_ptr = (uint8_t *)&task_stacks[task_count][STACK_SIZE - 1];
    uint16_t address = (uint16_t)task_func;
    *stack_ptr-- = (uint8_t)(address & 0x00FF);      // PC Low
    *stack_ptr-- = (uint8_t)((address >> 8) & 0x00FF); // PC High
    *stack_ptr-- = 0x00; //R0
    *stack_ptr-- = 0x80; //SREG: Global Interrupt Enable flag set
    *stack_ptr-- = 0x00; //R1
    for (int i = 2; i <= 31; i++) { //from R2 to R31
        *stack_ptr-- = 0x00;
    }

    tasks[task_count].sp = stack_ptr;
    tasks[task_count].delay_ticks = 0;
    tasks[task_count].id = task_count;
    strcpy(tasks[task_count].name, name);
    tasks[task_count].state = TASK_READY;
    tasks[task_count].blocked_on = NULL;
    task_count++;
    return tasks[task_count - 1].id;
}

void rtos_sem_init(Semaphore *sem, int8_t max_count, int8_t initial_count) {
    sem->max_count = max_count;
    sem->count = initial_count;
}

void rtos_sem_take(Semaphore *sem) {
    while(1) {
        rtos_enter_critical();
        if (sem->count > 0) {
            sem->count--;
            rtos_exit_critical();
            return;
        }
        tasks[current_task_index].state = TASK_BLOCKED;
        tasks[current_task_index].blocked_on = sem;
        rtos_exit_critical();
        rtos_yield();
    }
}

void rtos_sem_give(Semaphore *sem) {
    rtos_enter_critical();
    if (sem->count < sem->max_count) {
        sem->count++;
        for(int i = 0; i < task_count; i++) {
            if (tasks[i].state == TASK_BLOCKED && tasks[i].blocked_on == sem) {
                tasks[i].state = TASK_READY;
                tasks[i].blocked_on = 0;
                break; //NOTE: Wake up one task (priority handling could be added here)
            }
        }
    }
    rtos_exit_critical();
}

void rtos_enter_critical(void) {
    cli();
}
void rtos_exit_critical(void) {
    sei();
}

void rtos_sleep(uint16_t ms) {
    rtos_enter_critical();
    tasks[current_task_index].delay_ticks = ms;
    tasks[current_task_index].state = TASK_SLEEPING;
    rtos_exit_critical();
    rtos_yield();
}

void rtos_start(void) {
    if (task_count == 0) return;
    current_task_index = 0;
    current_sp = tasks[0].sp;
    RESTORE_CONTEXT();
}

void rtos_tick(void) {
    for (uint8_t i = 0; i < task_count; i++) {
        if (tasks[i].state == TASK_SLEEPING) {
            if (tasks[i].delay_ticks > 0) {
                tasks[i].delay_ticks--;
            }
            if (tasks[i].delay_ticks == 0) {
                tasks[i].state = TASK_READY;
            }
        }
    }
}

void rtos_scheduler(void) {
    tasks[current_task_index].sp = (uint8_t*)current_sp;

    uint8_t next_task = current_task_index;
    
    // Loop through tasks to find one that is ready
    // We start from next_task + 1 and wrap around
    // WARNING: do we really wrap around? why are we not using % then?
    // Since we have an Idle Task (delay=0), we are guaranteed to find one.
    do {
        next_task++;
        if (next_task >= task_count) next_task = 0;
        
        if (tasks[next_task].state == TASK_READY) {
            current_task_index = next_task;
            break;
        }
    } while (next_task != current_task_index);

    current_sp = tasks[current_task_index].sp;
}

ISR(TIMER0_COMPA_vect, ISR_NAKED) {
    SAVE_CONTEXT();

    asm volatile (
        "call rtos_tick \n\t"
        "call rtos_scheduler \n\t"
    );

    RESTORE_CONTEXT();
}

void __attribute__((naked)) rtos_yield(void) {
    SAVE_CONTEXT();
    asm volatile (
        "call rtos_scheduler \n\t"
    );
    RESTORE_CONTEXT();
}
