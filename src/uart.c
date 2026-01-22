#include <avr/io.h>
#include <avr/interrupt.h>
#include "uart.h"
#include "rtos.h"

// Line buffer for receiving commands
#define RX_BUFFER_SIZE 32
static volatile char rx_buffer[RX_BUFFER_SIZE];
static volatile uint8_t rx_index = 0;
static volatile uint8_t line_ready = 0;

// Semaphore to signal shell task when line is ready
static Semaphore shell_sem;

void uart_init(uint32_t baud) {
    uint16_t ubrr = F_CPU / 16 / baud - 1;
    
    // Set baud rate
    UBRR0H = (uint8_t)(ubrr >> 8);
    UBRR0L = (uint8_t)ubrr;
    
    // Enable receiver, transmitter, and RX complete interrupt
    UCSR0B = (1 << RXEN0) | (1 << TXEN0) | (1 << RXCIE0);
    
    // Set frame format: 8data, 2stop bit
    UCSR0C = (1 << USBS0) | (3 << UCSZ00);
    
    // Initialize shell semaphore (binary semaphore, starts at 0)
    rtos_sem_init(&shell_sem, 1, 0);
}

void uart_putc(char c) {
    // Wait for empty transmit buffer
    while (!(UCSR0A & (1 << UDRE0)));
    
    // Put data into buffer, sends the data
    UDR0 = c;
}

void uart_print(const char *str) {
    while (*str) {
        uart_putc(*str++);
    }
}

// UART RX interrupt handler
// Buffers characters until newline, then signals shell task
ISR(USART_RX_vect) {
    char c = UDR0;
    
    if (c == '\n' || c == '\r') {
        // Line complete - null terminate and signal shell
        rx_buffer[rx_index] = '\0';
        line_ready = 1;
        rx_index = 0;
        rtos_sem_give_from_isr(&shell_sem);  // Use ISR-safe version!
    } else if (rx_index < RX_BUFFER_SIZE - 1) {
        // Add character to buffer
        rx_buffer[rx_index++] = c;
    }
    // If buffer full, ignore additional chars until newline
}

// Block until a complete line is received, then copy it to dest
// Returns pointer to dest
char* uart_getline(char *dest, uint8_t max_len) {

    // Wait for line to be ready
    rtos_sem_take(&shell_sem);
    
    // Copy buffer to destination
    uint8_t i;
    for (i = 0; i < max_len - 1 && rx_buffer[i] != '\0'; i++) {
        dest[i] = rx_buffer[i];
    }
    dest[i] = '\0';
    
    line_ready = 0;
    return dest;
}
