# MCU Configuration
MCU = atmega328p
F_CPU = 16000000UL
BAUD = 57600
PROGRAMMER = arduino
PORT = /dev/ttyUSB0

# Directory Configuration
SRCDIR = src
INCDIR = inc
OBJDIR = obj
BINDIR = bin

# Toolchain
CC = avr-gcc
OBJCOPY = avr-objcopy
AVRDUDE = avrdude
SIZE = avr-size

# Flags
CFLAGS = -mmcu=$(MCU) -DF_CPU=$(F_CPU) -I$(INCDIR)
CFLAGS += -Os -Wall -Wextra -Wstrict-prototypes
CFLAGS += -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums
CFLAGS += -ffunction-sections -fdata-sections
CFLAGS += -std=gnu99

LDFLAGS = -mmcu=$(MCU) -Wl,--gc-sections

# Source and Object files
SOURCES = $(wildcard $(SRCDIR)/*.c)
OBJECTS = $(patsubst $(SRCDIR)/%.c, $(OBJDIR)/%.o, $(SOURCES))
TARGET = $(BINDIR)/rtos

# Targets
all: $(TARGET).hex

$(TARGET).elf: $(OBJECTS) | $(BINDIR)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@
	$(SIZE) --mcu=$(MCU) --format=avr $@

$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

$(OBJDIR)/%.o: $(SRCDIR)/%.c | $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJDIR):
	mkdir -p $(OBJDIR)

$(BINDIR):
	mkdir -p $(BINDIR)

flash: $(TARGET).hex
	$(AVRDUDE) -p $(MCU) -c $(PROGRAMMER) -P $(PORT) -b $(BAUD) -U flash:w:$<:i

monitor:
	stty -F $(PORT) $(BAUD) cs8 -cstopb -parenb raw -echo
	cat $(PORT)

clean:
	rm -rf $(OBJDIR) $(BINDIR)

.PHONY: all flash clean monitor
