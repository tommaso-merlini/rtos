#include <avr/io.h>
#include "uart.h"

void uart_init(uint32_t baud) {
    uint16_t ubrr = F_CPU / 16 / baud - 1;
    
    // Set baud rate
    UBRR0H = (uint8_t)(ubrr >> 8);
    UBRR0L = (uint8_t)ubrr;
    
    // Enable receiver and transmitter
    UCSR0B = (1 << RXEN0) | (1 << TXEN0);
    
    // Set frame format: 8data, 2stop bit
    UCSR0C = (1 << USBS0) | (3 << UCSZ00);
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
