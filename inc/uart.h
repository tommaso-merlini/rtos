#ifndef UART_H
#define UART_H

#include <stdint.h>
#include <avr/pgmspace.h>

void uart_init(uint32_t baud);
void uart_putc(char c);
void uart_print(const char *str);
void uart_print_P(const char *str);


// Blocking call - waits for a complete line (until \n), copies to dest
// Returns pointer to dest
char* uart_getline(char *dest, uint8_t max_len);

#endif // UART_H
