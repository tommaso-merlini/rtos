[x] Priority-Based Scheduling
    - Currently, rtos_scheduler iterates through tasks in a simple round-robin fashion, completely ignoring the uint8_t priority field already present in the TCB struct.
    - Why: Real-time systems require high-priority tasks (e.g., sensor reading, motor control) to preempt lower-priority ones (e.g., logging, UI).
    - Implementation: Modify rtos_scheduler to scan the tasks array and select the TASK_READY task with the highest priority value instead of just the next one in the list.

    WHAT WE IMPLEMENTED SUFFERS OF STARVATION -> SOLUTION: PRIORITY AGING


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

[x] Stack Overflow Detection
    - There is currently no protection against a task writing beyond its STACK_SIZE (128 bytes).
    - Why: Stack overflows are a common cause of hard-to-debug crashes in embedded systems.
    - Implementation: Fill the stack area with a known pattern (e.g., 0xDEADBEEF) during creation. Check if this pattern is overwritten at the end of the stack during every context switch (rtos_scheduler).

[x] UART Command Shell (CLI)
    -   Concept: Create a task that listens to UART input and parses commands like ps (process status), kill <id>, or servo <angle>.
    -   Why: It turns your device into an interactive computer rather than a static firmware.

[] Implement a proper rtos_join or sem_take_timeout feature to replace this polling loop
    - see lines 186-187-188 in shell.c

[] "Top" Command (CPU Usage Monitor)
    -   Concept: Modify the scheduler to track how many "ticks" each task consumes. Create a task that prints the CPU percentage for every task (like the Linux top command).
    -   Why: Essential for analyzing performance and finding tasks that hog the CPU.

[x] Inter-Task Messaging (Mailboxes)
    -   Concept: Currently, tasks synchronize via Semaphores (signals). Add "Mailboxes" so tasks can send actual data (integers or struct pointers) to each other safely.
    -   Why: Allows for complex producer-consumer architectures (e.g., a sensor task sending data to a processing task).

[] Priority Inversion "Solver"
    -   Concept: Implement Priority Inheritance.
    -   Why: It's a classic RTOS problem. If a Low Priority task holds a lock that a High Priority task needs, the High Priority task is blocked. If a Medium Priority task runs, it prevents the Low one from releasing the lock, effectively blocking the High one indefinitely. Solving this is "pro-level" RTOS development.

[] Servo Waveform Generator
    -   Concept: A dedicated task that calculates sine or triangle waves (using floating point or lookup tables) to drive the servo in smooth, organic sweeping motions instead of jerky jumps.

[] Software Watchdog
    -   Concept: A system task that requires other tasks to "check-in" periodically. If a task gets stuck (deadlock or infinite loop), the watchdog detects it and restarts that specific task or the whole system.
