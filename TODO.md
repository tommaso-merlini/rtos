[] Priority-Based Scheduling
    - Currently, rtos_scheduler iterates through tasks in a simple round-robin fashion, completely ignoring the uint8_t priority field already present in the TCB struct.
    - Why: Real-time systems require high-priority tasks (e.g., sensor reading, motor control) to preempt lower-priority ones (e.g., logging, UI).
    - Implementation: Modify rtos_scheduler to scan the tasks array and select the TASK_READY task with the highest priority value instead of just the next one in the list.

[] Message Queues (IPC)
    - The system currently relies on global variables protected by semaphores for communication (as seen in main.c).
    - Why: Shared global variables are error-prone and hard to scale. Queues allow tasks to safely pass data (messages) to each other without manual synchronization handling.
    - Implementation: Create a Queue struct (buffer, head, tail, size) and functions rtos_queue_send and rtos_queue_receive. These should block (putting the task to sleep) if the queue is full (sending) or empty (receiving).

[x] Task Deletion & Return Handling
    - Currently, if a task function returns (reaches the end of its function body), the CPU will pop a garbage address from the stack and crash, as there is no return address.
    - Why: Tasks may need to finish their work and stop.
    - Implementation:
        - Implement rtos_delete_task(uint8_t id) to mark a task as free/unused.
        - Initialize the stack with a "return hook" address (a function that calls rtos_delete_task(self)) so that if a task function returns, it gracefully deletes itself.

[] Stack Overflow Detection
    - There is currently no protection against a task writing beyond its STACK_SIZE (128 bytes).
    - Why: Stack overflows are a common cause of hard-to-debug crashes in embedded systems.
    - Implementation: Fill the stack area with a known pattern (e.g., 0xDEADBEEF) during creation. Check if this pattern is overwritten at the end of the stack during every context switch (rtos_scheduler).
