#include <avr/io.h>
#include <avr/interrupt.h>
#include <stdint.h>
#include <string.h>
#include <util/delay.h>
#include "../inc/rtos.h"
#include "../inc/uart.h"

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

volatile uint8_t ready_priority_group = 0;
volatile uint8_t priority_counts[8] = {0};

void idle_task(void) {
    while(1) { }
}

//WARNING: MUST be called with interrupts disabled or inside critical section
void rtos_set_task_state(uint8_t index, TaskState new_state) {
    if (index >= MAX_TASKS) return;
    
    TaskState old_state = tasks[index].state;
    if (old_state == new_state) return;
    
    uint8_t prio = tasks[index].priority;
    
    if (old_state == TASK_READY) {
        if (priority_counts[prio] > 0) {
            priority_counts[prio]--;
            if (priority_counts[prio] == 0) {
                ready_priority_group &= ~(1 << prio);
            }
        }
    }
    
    if (new_state == TASK_READY) {
        if (priority_counts[prio] == 0) {
            ready_priority_group |= (1 << prio);
        }
        priority_counts[prio]++;
    }
    
    tasks[index].state = new_state;
}

void init_timer0(void) {
    TCCR0A = (1 << WGM01); // CTC mode
    TCCR0B = (1 << CS01) | (1 << CS00); // Prescaler 64
    OCR0A = 249; 
    TIMSK0 = (1 << OCIE0A); // Enable Compare Match A interrupt
}

void rtos_init(void) {
    task_count = 0;
    current_task_index = 0;
    
    ready_priority_group = 0;
    memset((void*)priority_counts, 0, sizeof(priority_counts));

    for(int i = 0; i < MAX_TASKS; i++) {
        tasks[i].state = TASK_EMPTY;
    }

    rtos_create_task(idle_task, 0, "idle task");
}

void rtos_delete_task(uint8_t id) {
    rtos_enter_critical();
    if (id < MAX_TASKS) {
        rtos_set_task_state(id, TASK_DELETED);
    }
    rtos_exit_critical();
    
    if (id == current_task_index) {
        rtos_suicide();
    }
}

void rtos_task_exit(void) {
    rtos_delete_task(current_task_index);
}

int8_t rtos_create_task(void (*task_func)(void), uint8_t priority, char name[16]) {
    int slot = -1;
    
    for (int i = 0; i < MAX_TASKS; i++) {
        if (tasks[i].state == TASK_EMPTY || tasks[i].state == TASK_DELETED) {
            slot = i;
            break;
        }
    }
    
    if (slot == -1) return -1;
    if (slot >= task_count) task_count = slot + 1; //WARNING: why? the task count should only count the running tasks
    
    uint8_t *stack_ptr = (uint8_t *)&task_stacks[slot][STACK_SIZE - 1];
    
    uint16_t exit_address = (uint16_t)rtos_task_exit;
    *stack_ptr-- = (uint8_t)(exit_address & 0x00FF);
    *stack_ptr-- = (uint8_t)((exit_address >> 8) & 0x00FF);
    uint16_t address = (uint16_t)task_func;
    *stack_ptr-- = (uint8_t)(address & 0x00FF);
    *stack_ptr-- = (uint8_t)((address >> 8) & 0x00FF);
    *stack_ptr-- = 0x00; //R0
    *stack_ptr-- = 0x80; //SREG: Global Interrupt Enable flag set
    *stack_ptr-- = 0x00; //R1
    for (int i = 2; i <= 31; i++) { //from R2 to R31
        *stack_ptr-- = 0x00;
    }

    tasks[slot].sp = stack_ptr;
    tasks[slot].stack_limit = &task_stacks[slot][0];
    tasks[slot].delay_ticks = 0;
    tasks[slot].id = slot;
    strcpy(tasks[slot].name, name);
    tasks[slot].blocked_on = NULL;
    tasks[slot].priority = priority;
    
    rtos_enter_critical();
    rtos_set_task_state(slot, TASK_READY);
    rtos_exit_critical();
    
    return slot;
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
        rtos_set_task_state(current_task_index, TASK_BLOCKED);
        tasks[current_task_index].blocked_on = sem;
        rtos_exit_critical();
        rtos_yield();
    }
}

uint8_t rtos_sem_try_take(Semaphore *sem) {
    rtos_enter_critical();
    if (sem->count > 0) {
        sem->count--;
        rtos_exit_critical();
        return 1;
    }
    rtos_exit_critical();
    return 0;
}

void rtos_sem_give(Semaphore *sem) {
    uint8_t sreg = SREG;
    cli();
    if (sem->count < sem->max_count) {
        sem->count++;
        for(int i = 0; i < task_count; i++) {
            if (tasks[i].state == TASK_BLOCKED && tasks[i].blocked_on == sem) {
                rtos_set_task_state(i, TASK_READY);
                tasks[i].blocked_on = 0;
                break;
            }
        }
    }
    SREG = sreg;
}

void rtos_mailbox_init(Mailbox *mb) {
    rtos_sem_init(&mb->has_data, 1, 0);
    rtos_sem_init(&mb->has_space, 1, 1);
}

void rtos_mailbox_send(Mailbox *mb, void *data, uint8_t size) {
    rtos_sem_take(&mb->has_space);
    rtos_enter_critical();
    for (uint8_t i = 0; i < size && i < 4; i++) {
        mb->data[i] = ((uint8_t*)data)[i];
    }
    rtos_exit_critical();
    rtos_sem_give(&mb->has_data);
}

void rtos_mailbox_receive(Mailbox *mb, void *data, uint8_t size) {
    rtos_sem_take(&mb->has_data);
    rtos_enter_critical();
    for (uint8_t i = 0; i < size && i < 4; i++) {
        ((uint8_t*)data)[i] = mb->data[i];
    }
    rtos_exit_critical();
    rtos_sem_give(&mb->has_space);
}

uint8_t rtos_mailbox_try_send(Mailbox *mb, void *data, uint8_t size) {
    if (!rtos_sem_try_take(&mb->has_space)) {
        return 0;
    }
    
    rtos_enter_critical();
    for (uint8_t i = 0; i < size && i < 4; i++) {
        mb->data[i] = ((uint8_t*)data)[i];
    }
    rtos_exit_critical();
    rtos_sem_give(&mb->has_data); 
    return 1;
}

uint8_t rtos_mailbox_try_receive(Mailbox *mb, void *data, uint8_t size) {
    if (!rtos_sem_try_take(&mb->has_data)) {
        return 0;
    }
    
    rtos_enter_critical();
    for (uint8_t i = 0; i < size && i < 4; i++) {
        ((uint8_t*)data)[i] = mb->data[i];
    }
    rtos_exit_critical();
    rtos_sem_give(&mb->has_space);  
    return 1;
}

void rtos_enter_critical(void) {
    cli();
}

void rtos_exit_critical(void) {
    sei();
}

static uint8_t scheduler_started = 0;

void rtos_scheduler(void) {
    // Skip saving context on first call - there's no valid context yet
    if (scheduler_started) {
        tasks[current_task_index].sp = (uint8_t*)current_sp;
        
        // Stack overflow check
        if (tasks[current_task_index].sp < tasks[current_task_index].stack_limit) {
            cli();  // Disable interrupts
            uart_print("PANIC: Stack overflow in task: ");
            uart_print(tasks[current_task_index].name);
            uart_print("\r\n");
            while (1);  // Halt
        }
    }
    scheduler_started = 1;
    if (ready_priority_group == 0) {
        current_task_index = 0; 
    } else {
        int8_t highest_prio = -1;
        for (int8_t p = 7; p >= 0; p--) {
            if (ready_priority_group & (1 << p)) {
                highest_prio = p;
                break;
            }
        }
        uint8_t next_task = current_task_index;
        uint8_t found = 0;
        do {
            next_task++;
            if (next_task >= task_count) next_task = 0;
            if (next_task == 0 && ready_priority_group > 1) continue; 
            if (tasks[next_task].state == TASK_READY && 
                tasks[next_task].priority == highest_prio) {
                current_task_index = next_task;
                found = 1;
                break;
            }
        } while (next_task != current_task_index);
        if (!found && highest_prio != -1) {
            current_task_index = 0;
        }
    }
    current_sp = tasks[current_task_index].sp;
}

void rtos_sleep(uint16_t ms) {
    rtos_enter_critical();
    tasks[current_task_index].delay_ticks = ms;
    rtos_set_task_state(current_task_index, TASK_SLEEPING);
    rtos_exit_critical();
    rtos_yield();
}

void rtos_start(void) {
    if (task_count == 0) return;
    
    // Start the timer AFTER scheduler is ready
    init_timer0();
    
    rtos_scheduler();
    current_sp = tasks[current_task_index].sp;
    RESTORE_CONTEXT();
}

void rtos_tick(void) {
    for (uint8_t i = 0; i < task_count; i++) {
        if (tasks[i].state == TASK_SLEEPING) {
            if (tasks[i].delay_ticks > 0) {
                tasks[i].delay_ticks--;
            }
            if (tasks[i].delay_ticks == 0) {
                rtos_set_task_state(i, TASK_READY);
            }
        }
    }
}

ISR(TIMER0_COMPA_vect, ISR_NAKED) {
    SAVE_CONTEXT();

    asm volatile (
        "call rtos_tick \n\t" //NOTE: we dont need to enter a critical section because ISR already disables the interrupts
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

void __attribute__((naked)) rtos_suicide(void) {
    asm volatile (
        "call rtos_scheduler \n\t"
    );
    RESTORE_CONTEXT();
}
