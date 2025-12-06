
./bin/rtos.elf:     file format elf32-avr


Disassembly of section .text:

00000000 <__vectors>:
   0:	0c 94 34 00 	jmp	0x68	; 0x68 <__ctors_end>
   4:	0c 94 51 00 	jmp	0xa2	; 0xa2 <__bad_interrupt>
   8:	0c 94 51 00 	jmp	0xa2	; 0xa2 <__bad_interrupt>
   c:	0c 94 51 00 	jmp	0xa2	; 0xa2 <__bad_interrupt>
  10:	0c 94 51 00 	jmp	0xa2	; 0xa2 <__bad_interrupt>
  14:	0c 94 51 00 	jmp	0xa2	; 0xa2 <__bad_interrupt>
  18:	0c 94 51 00 	jmp	0xa2	; 0xa2 <__bad_interrupt>
  1c:	0c 94 51 00 	jmp	0xa2	; 0xa2 <__bad_interrupt>
  20:	0c 94 51 00 	jmp	0xa2	; 0xa2 <__bad_interrupt>
  24:	0c 94 51 00 	jmp	0xa2	; 0xa2 <__bad_interrupt>
  28:	0c 94 51 00 	jmp	0xa2	; 0xa2 <__bad_interrupt>
  2c:	0c 94 51 00 	jmp	0xa2	; 0xa2 <__bad_interrupt>
  30:	0c 94 51 00 	jmp	0xa2	; 0xa2 <__bad_interrupt>
  34:	0c 94 51 00 	jmp	0xa2	; 0xa2 <__bad_interrupt>
  38:	0c 94 f2 01 	jmp	0x3e4	; 0x3e4 <__vector_14>
  3c:	0c 94 51 00 	jmp	0xa2	; 0xa2 <__bad_interrupt>
  40:	0c 94 51 00 	jmp	0xa2	; 0xa2 <__bad_interrupt>
  44:	0c 94 51 00 	jmp	0xa2	; 0xa2 <__bad_interrupt>
  48:	0c 94 51 00 	jmp	0xa2	; 0xa2 <__bad_interrupt>
  4c:	0c 94 51 00 	jmp	0xa2	; 0xa2 <__bad_interrupt>
  50:	0c 94 51 00 	jmp	0xa2	; 0xa2 <__bad_interrupt>
  54:	0c 94 51 00 	jmp	0xa2	; 0xa2 <__bad_interrupt>
  58:	0c 94 51 00 	jmp	0xa2	; 0xa2 <__bad_interrupt>
  5c:	0c 94 51 00 	jmp	0xa2	; 0xa2 <__bad_interrupt>
  60:	0c 94 51 00 	jmp	0xa2	; 0xa2 <__bad_interrupt>
  64:	0c 94 51 00 	jmp	0xa2	; 0xa2 <__bad_interrupt>

00000068 <__ctors_end>:
  68:	11 24       	eor	r1, r1
  6a:	1f be       	out	0x3f, r1	; 63
  6c:	cf ef       	ldi	r28, 0xFF	; 255
  6e:	d8 e0       	ldi	r29, 0x08	; 8
  70:	de bf       	out	0x3e, r29	; 62
  72:	cd bf       	out	0x3d, r28	; 61

00000074 <__do_copy_data>:
  74:	11 e0       	ldi	r17, 0x01	; 1
  76:	a0 e0       	ldi	r26, 0x00	; 0
  78:	b1 e0       	ldi	r27, 0x01	; 1
  7a:	ee e7       	ldi	r30, 0x7E	; 126
  7c:	f7 e0       	ldi	r31, 0x07	; 7
  7e:	02 c0       	rjmp	.+4      	; 0x84 <__do_copy_data+0x10>
  80:	05 90       	lpm	r0, Z+
  82:	0d 92       	st	X+, r0
  84:	a4 34       	cpi	r26, 0x44	; 68
  86:	b1 07       	cpc	r27, r17
  88:	d9 f7       	brne	.-10     	; 0x80 <__do_copy_data+0xc>

0000008a <__do_clear_bss>:
  8a:	23 e0       	ldi	r18, 0x03	; 3
  8c:	a4 e4       	ldi	r26, 0x44	; 68
  8e:	b1 e0       	ldi	r27, 0x01	; 1
  90:	01 c0       	rjmp	.+2      	; 0x94 <.do_clear_bss_start>

00000092 <.do_clear_bss_loop>:
  92:	1d 92       	st	X+, r1

00000094 <.do_clear_bss_start>:
  94:	ad 35       	cpi	r26, 0x5D	; 93
  96:	b2 07       	cpc	r27, r18
  98:	e1 f7       	brne	.-8      	; 0x92 <.do_clear_bss_loop>
  9a:	0e 94 c7 00 	call	0x18e	; 0x18e <main>
  9e:	0c 94 bd 03 	jmp	0x77a	; 0x77a <_exit>

000000a2 <__bad_interrupt>:
  a2:	0c 94 00 00 	jmp	0	; 0x0 <__vectors>

000000a6 <print_num>:
  a6:	ef 92       	push	r14
  a8:	ff 92       	push	r15
  aa:	0f 93       	push	r16
  ac:	1f 93       	push	r17
  ae:	cf 93       	push	r28
  b0:	df 93       	push	r29
  b2:	00 d0       	rcall	.+0      	; 0xb4 <print_num+0xe>
  b4:	00 d0       	rcall	.+0      	; 0xb6 <print_num+0x10>
  b6:	cd b7       	in	r28, 0x3d	; 61
  b8:	de b7       	in	r29, 0x3e	; 62
  ba:	81 11       	cpse	r24, r1
  bc:	0d c0       	rjmp	.+26     	; 0xd8 <print_num+0x32>
  be:	80 e3       	ldi	r24, 0x30	; 48
  c0:	0f 90       	pop	r0
  c2:	0f 90       	pop	r0
  c4:	0f 90       	pop	r0
  c6:	0f 90       	pop	r0
  c8:	df 91       	pop	r29
  ca:	cf 91       	pop	r28
  cc:	1f 91       	pop	r17
  ce:	0f 91       	pop	r16
  d0:	ff 90       	pop	r15
  d2:	ef 90       	pop	r14
  d4:	0c 94 5b 02 	jmp	0x4b6	; 0x4b6 <uart_putc>
  d8:	9e 01       	movw	r18, r28
  da:	2f 5f       	subi	r18, 0xFF	; 255
  dc:	3f 4f       	sbci	r19, 0xFF	; 255
  de:	79 01       	movw	r14, r18
  e0:	f9 01       	movw	r30, r18
  e2:	00 e0       	ldi	r16, 0x00	; 0
  e4:	10 e0       	ldi	r17, 0x00	; 0
  e6:	2a e0       	ldi	r18, 0x0A	; 10
  e8:	0f 5f       	subi	r16, 0xFF	; 255
  ea:	1f 4f       	sbci	r17, 0xFF	; 255
  ec:	62 2f       	mov	r22, r18
  ee:	0e 94 6e 02 	call	0x4dc	; 0x4dc <__udivmodqi4>
  f2:	90 5d       	subi	r25, 0xD0	; 208
  f4:	91 93       	st	Z+, r25
  f6:	81 11       	cpse	r24, r1
  f8:	f7 cf       	rjmp	.-18     	; 0xe8 <print_num+0x42>
  fa:	0e 0d       	add	r16, r14
  fc:	1f 1d       	adc	r17, r15
  fe:	0e 15       	cp	r16, r14
 100:	1f 05       	cpc	r17, r15
 102:	31 f0       	breq	.+12     	; 0x110 <print_num+0x6a>
 104:	f8 01       	movw	r30, r16
 106:	82 91       	ld	r24, -Z
 108:	8f 01       	movw	r16, r30
 10a:	0e 94 5b 02 	call	0x4b6	; 0x4b6 <uart_putc>
 10e:	f7 cf       	rjmp	.-18     	; 0xfe <print_num+0x58>
 110:	0f 90       	pop	r0
 112:	0f 90       	pop	r0
 114:	0f 90       	pop	r0
 116:	0f 90       	pop	r0
 118:	df 91       	pop	r29
 11a:	cf 91       	pop	r28
 11c:	1f 91       	pop	r17
 11e:	0f 91       	pop	r16
 120:	ff 90       	pop	r15
 122:	ef 90       	pop	r14
 124:	08 95       	ret

00000126 <task1>:
 126:	0e 94 4d 01 	call	0x29a	; 0x29a <rtos_enter_critical>
 12a:	80 91 44 01 	lds	r24, 0x0144	; 0x800144 <__data_end>
 12e:	8f 5f       	subi	r24, 0xFF	; 255
 130:	80 93 44 01 	sts	0x0144, r24	; 0x800144 <__data_end>
 134:	0e 94 4f 01 	call	0x29e	; 0x29e <rtos_exit_critical>
 138:	86 e0       	ldi	r24, 0x06	; 6
 13a:	91 e0       	ldi	r25, 0x01	; 1
 13c:	0e 94 62 02 	call	0x4c4	; 0x4c4 <uart_print>
 140:	80 91 44 01 	lds	r24, 0x0144	; 0x800144 <__data_end>
 144:	0e 94 53 00 	call	0xa6	; 0xa6 <print_num>
 148:	8f e2       	ldi	r24, 0x2F	; 47
 14a:	91 e0       	ldi	r25, 0x01	; 1
 14c:	0e 94 62 02 	call	0x4c4	; 0x4c4 <uart_print>
 150:	84 ef       	ldi	r24, 0xF4	; 244
 152:	91 e0       	ldi	r25, 0x01	; 1
 154:	0e 94 51 01 	call	0x2a2	; 0x2a2 <rtos_sleep>
 158:	e6 cf       	rjmp	.-52     	; 0x126 <task1>

0000015a <task2>:
 15a:	88 ee       	ldi	r24, 0xE8	; 232
 15c:	93 e0       	ldi	r25, 0x03	; 3
 15e:	0e 94 51 01 	call	0x2a2	; 0x2a2 <rtos_sleep>
 162:	0e 94 4d 01 	call	0x29a	; 0x29a <rtos_enter_critical>
 166:	80 91 44 01 	lds	r24, 0x0144	; 0x800144 <__data_end>
 16a:	82 50       	subi	r24, 0x02	; 2
 16c:	80 93 44 01 	sts	0x0144, r24	; 0x800144 <__data_end>
 170:	0e 94 4f 01 	call	0x29e	; 0x29e <rtos_exit_critical>
 174:	8e e0       	ldi	r24, 0x0E	; 14
 176:	91 e0       	ldi	r25, 0x01	; 1
 178:	0e 94 62 02 	call	0x4c4	; 0x4c4 <uart_print>
 17c:	80 91 44 01 	lds	r24, 0x0144	; 0x800144 <__data_end>
 180:	0e 94 53 00 	call	0xa6	; 0xa6 <print_num>
 184:	8f e2       	ldi	r24, 0x2F	; 47
 186:	91 e0       	ldi	r25, 0x01	; 1
 188:	0e 94 62 02 	call	0x4c4	; 0x4c4 <uart_print>
 18c:	e6 cf       	rjmp	.-52     	; 0x15a <task2>

0000018e <main>:
 18e:	25 9a       	sbi	0x04, 5	; 4
 190:	60 e0       	ldi	r22, 0x00	; 0
 192:	71 ee       	ldi	r23, 0xE1	; 225
 194:	80 e0       	ldi	r24, 0x00	; 0
 196:	90 e0       	ldi	r25, 0x00	; 0
 198:	0e 94 46 02 	call	0x48c	; 0x48c <uart_init>
 19c:	2f ef       	ldi	r18, 0xFF	; 255
 19e:	8f e4       	ldi	r24, 0x4F	; 79
 1a0:	93 ec       	ldi	r25, 0xC3	; 195
 1a2:	21 50       	subi	r18, 0x01	; 1
 1a4:	80 40       	sbci	r24, 0x00	; 0
 1a6:	90 40       	sbci	r25, 0x00	; 0
 1a8:	e1 f7       	brne	.-8      	; 0x1a2 <main+0x14>
 1aa:	00 c0       	rjmp	.+0      	; 0x1ac <main+0x1e>
 1ac:	00 00       	nop
 1ae:	86 e1       	ldi	r24, 0x16	; 22
 1b0:	91 e0       	ldi	r25, 0x01	; 1
 1b2:	0e 94 62 02 	call	0x4c4	; 0x4c4 <uart_print>
 1b6:	82 e0       	ldi	r24, 0x02	; 2
 1b8:	90 e0       	ldi	r25, 0x00	; 0
 1ba:	0e 94 9c 02 	call	0x538	; 0x538 <malloc>
 1be:	89 2b       	or	r24, r25
 1c0:	31 f0       	breq	.+12     	; 0x1ce <main+0x40>
 1c2:	84 e6       	ldi	r24, 0x64	; 100
 1c4:	0e 94 53 00 	call	0xa6	; 0xa6 <print_num>
 1c8:	8f e2       	ldi	r24, 0x2F	; 47
 1ca:	91 e0       	ldi	r25, 0x01	; 1
 1cc:	02 c0       	rjmp	.+4      	; 0x1d2 <main+0x44>
 1ce:	89 e2       	ldi	r24, 0x29	; 41
 1d0:	91 e0       	ldi	r25, 0x01	; 1
 1d2:	0e 94 62 02 	call	0x4c4	; 0x4c4 <uart_print>
 1d6:	0e 94 42 01 	call	0x284	; 0x284 <rtos_init>
 1da:	61 e0       	ldi	r22, 0x01	; 1
 1dc:	83 e9       	ldi	r24, 0x93	; 147
 1de:	90 e0       	ldi	r25, 0x00	; 0
 1e0:	0e 94 08 01 	call	0x210	; 0x210 <rtos_create_task>
 1e4:	61 e0       	ldi	r22, 0x01	; 1
 1e6:	8d ea       	ldi	r24, 0xAD	; 173
 1e8:	90 e0       	ldi	r25, 0x00	; 0
 1ea:	0e 94 08 01 	call	0x210	; 0x210 <rtos_create_task>
 1ee:	81 e3       	ldi	r24, 0x31	; 49
 1f0:	91 e0       	ldi	r25, 0x01	; 1
 1f2:	0e 94 62 02 	call	0x4c4	; 0x4c4 <uart_print>
 1f6:	0e 94 68 01 	call	0x2d0	; 0x2d0 <rtos_start>
 1fa:	ff cf       	rjmp	.-2      	; 0x1fa <main+0x6c>

000001fc <idle_task>:
 1fc:	ff cf       	rjmp	.-2      	; 0x1fc <idle_task>

000001fe <init_timer0>:
 1fe:	82 e0       	ldi	r24, 0x02	; 2
 200:	84 bd       	out	0x24, r24	; 36
 202:	93 e0       	ldi	r25, 0x03	; 3
 204:	95 bd       	out	0x25, r25	; 37
 206:	99 ef       	ldi	r25, 0xF9	; 249
 208:	97 bd       	out	0x27, r25	; 39
 20a:	80 93 6e 00 	sts	0x006E, r24	; 0x80006e <__TEXT_REGION_LENGTH__+0x7f806e>
 20e:	08 95       	ret

00000210 <rtos_create_task>:
 210:	20 91 46 01 	lds	r18, 0x0146	; 0x800146 <task_count>
 214:	24 30       	cpi	r18, 0x04	; 4
 216:	a8 f5       	brcc	.+106    	; 0x282 <rtos_create_task+0x72>
 218:	40 91 46 01 	lds	r20, 0x0146	; 0x800146 <task_count>
 21c:	20 e8       	ldi	r18, 0x80	; 128
 21e:	42 9f       	mul	r20, r18
 220:	a0 01       	movw	r20, r0
 222:	11 24       	eor	r1, r1
 224:	9a 01       	movw	r18, r20
 226:	2a 52       	subi	r18, 0x2A	; 42
 228:	3e 4f       	sbci	r19, 0xFE	; 254
 22a:	f9 01       	movw	r30, r18
 22c:	80 83       	st	Z, r24
 22e:	31 97       	sbiw	r30, 0x01	; 1
 230:	90 83       	st	Z, r25
 232:	31 97       	sbiw	r30, 0x01	; 1
 234:	10 82       	st	Z, r1
 236:	31 97       	sbiw	r30, 0x01	; 1
 238:	80 e8       	ldi	r24, 0x80	; 128
 23a:	80 83       	st	Z, r24
 23c:	31 97       	sbiw	r30, 0x01	; 1
 23e:	10 82       	st	Z, r1
 240:	c9 01       	movw	r24, r18
 242:	82 97       	sbiw	r24, 0x22	; 34
 244:	12 92       	st	-Z, r1
 246:	e8 17       	cp	r30, r24
 248:	f9 07       	cpc	r31, r25
 24a:	e1 f7       	brne	.-8      	; 0x244 <rtos_create_task+0x34>
 24c:	e0 91 46 01 	lds	r30, 0x0146	; 0x800146 <task_count>
 250:	84 e0       	ldi	r24, 0x04	; 4
 252:	e8 9f       	mul	r30, r24
 254:	f0 01       	movw	r30, r0
 256:	11 24       	eor	r1, r1
 258:	e9 5b       	subi	r30, 0xB9	; 185
 25a:	fe 4f       	sbci	r31, 0xFE	; 254
 25c:	23 52       	subi	r18, 0x23	; 35
 25e:	31 09       	sbc	r19, r1
 260:	31 83       	std	Z+1, r19	; 0x01
 262:	20 83       	st	Z, r18
 264:	e0 91 46 01 	lds	r30, 0x0146	; 0x800146 <task_count>
 268:	24 e0       	ldi	r18, 0x04	; 4
 26a:	e2 9f       	mul	r30, r18
 26c:	f0 01       	movw	r30, r0
 26e:	11 24       	eor	r1, r1
 270:	e9 5b       	subi	r30, 0xB9	; 185
 272:	fe 4f       	sbci	r31, 0xFE	; 254
 274:	13 82       	std	Z+3, r1	; 0x03
 276:	12 82       	std	Z+2, r1	; 0x02
 278:	80 91 46 01 	lds	r24, 0x0146	; 0x800146 <task_count>
 27c:	8f 5f       	subi	r24, 0xFF	; 255
 27e:	80 93 46 01 	sts	0x0146, r24	; 0x800146 <task_count>
 282:	08 95       	ret

00000284 <rtos_init>:
 284:	0e 94 ff 00 	call	0x1fe	; 0x1fe <init_timer0>
 288:	10 92 46 01 	sts	0x0146, r1	; 0x800146 <task_count>
 28c:	10 92 45 01 	sts	0x0145, r1	; 0x800145 <current_task_index>
 290:	60 e0       	ldi	r22, 0x00	; 0
 292:	8e ef       	ldi	r24, 0xFE	; 254
 294:	90 e0       	ldi	r25, 0x00	; 0
 296:	0c 94 08 01 	jmp	0x210	; 0x210 <rtos_create_task>

0000029a <rtos_enter_critical>:
 29a:	f8 94       	cli
 29c:	08 95       	ret

0000029e <rtos_exit_critical>:
 29e:	78 94       	sei
 2a0:	08 95       	ret

000002a2 <rtos_sleep>:
 2a2:	e0 91 45 01 	lds	r30, 0x0145	; 0x800145 <current_task_index>
 2a6:	24 e0       	ldi	r18, 0x04	; 4
 2a8:	e2 9f       	mul	r30, r18
 2aa:	f0 01       	movw	r30, r0
 2ac:	11 24       	eor	r1, r1
 2ae:	e9 5b       	subi	r30, 0xB9	; 185
 2b0:	fe 4f       	sbci	r31, 0xFE	; 254
 2b2:	93 83       	std	Z+3, r25	; 0x03
 2b4:	82 83       	std	Z+2, r24	; 0x02
 2b6:	e0 91 45 01 	lds	r30, 0x0145	; 0x800145 <current_task_index>
 2ba:	84 e0       	ldi	r24, 0x04	; 4
 2bc:	e8 9f       	mul	r30, r24
 2be:	f0 01       	movw	r30, r0
 2c0:	11 24       	eor	r1, r1
 2c2:	e9 5b       	subi	r30, 0xB9	; 185
 2c4:	fe 4f       	sbci	r31, 0xFE	; 254
 2c6:	82 81       	ldd	r24, Z+2	; 0x02
 2c8:	93 81       	ldd	r25, Z+3	; 0x03
 2ca:	89 2b       	or	r24, r25
 2cc:	a1 f7       	brne	.-24     	; 0x2b6 <rtos_sleep+0x14>
 2ce:	08 95       	ret

000002d0 <rtos_start>:
 2d0:	80 91 46 01 	lds	r24, 0x0146	; 0x800146 <task_count>
 2d4:	88 23       	and	r24, r24
 2d6:	09 f4       	brne	.+2      	; 0x2da <rtos_start+0xa>
 2d8:	37 c0       	rjmp	.+110    	; 0x348 <rtos_start+0x78>
 2da:	10 92 45 01 	sts	0x0145, r1	; 0x800145 <current_task_index>
 2de:	80 91 47 01 	lds	r24, 0x0147	; 0x800147 <tasks>
 2e2:	90 91 48 01 	lds	r25, 0x0148	; 0x800148 <tasks+0x1>
 2e6:	90 93 58 03 	sts	0x0358, r25	; 0x800358 <current_sp+0x1>
 2ea:	80 93 57 03 	sts	0x0357, r24	; 0x800357 <current_sp>
 2ee:	80 91 57 03 	lds	r24, 0x0357	; 0x800357 <current_sp>
 2f2:	90 91 58 03 	lds	r25, 0x0358	; 0x800358 <current_sp+0x1>
 2f6:	8d bf       	out	0x3d, r24	; 61
 2f8:	80 91 57 03 	lds	r24, 0x0357	; 0x800357 <current_sp>
 2fc:	90 91 58 03 	lds	r25, 0x0358	; 0x800358 <current_sp+0x1>
 300:	9e bf       	out	0x3e, r25	; 62
 302:	ff 91       	pop	r31
 304:	ef 91       	pop	r30
 306:	df 91       	pop	r29
 308:	cf 91       	pop	r28
 30a:	bf 91       	pop	r27
 30c:	af 91       	pop	r26
 30e:	9f 91       	pop	r25
 310:	8f 91       	pop	r24
 312:	7f 91       	pop	r23
 314:	6f 91       	pop	r22
 316:	5f 91       	pop	r21
 318:	4f 91       	pop	r20
 31a:	3f 91       	pop	r19
 31c:	2f 91       	pop	r18
 31e:	1f 91       	pop	r17
 320:	0f 91       	pop	r16
 322:	ff 90       	pop	r15
 324:	ef 90       	pop	r14
 326:	df 90       	pop	r13
 328:	cf 90       	pop	r12
 32a:	bf 90       	pop	r11
 32c:	af 90       	pop	r10
 32e:	9f 90       	pop	r9
 330:	8f 90       	pop	r8
 332:	7f 90       	pop	r7
 334:	6f 90       	pop	r6
 336:	5f 90       	pop	r5
 338:	4f 90       	pop	r4
 33a:	3f 90       	pop	r3
 33c:	2f 90       	pop	r2
 33e:	1f 90       	pop	r1
 340:	0f 90       	pop	r0
 342:	0f be       	out	0x3f, r0	; 63
 344:	0f 90       	pop	r0
 346:	18 95       	reti
 348:	08 95       	ret

0000034a <rtos_scheduler_update>:
 34a:	e0 91 45 01 	lds	r30, 0x0145	; 0x800145 <current_task_index>
 34e:	80 91 57 03 	lds	r24, 0x0357	; 0x800357 <current_sp>
 352:	90 91 58 03 	lds	r25, 0x0358	; 0x800358 <current_sp+0x1>
 356:	24 e0       	ldi	r18, 0x04	; 4
 358:	e2 9f       	mul	r30, r18
 35a:	f0 01       	movw	r30, r0
 35c:	11 24       	eor	r1, r1
 35e:	e9 5b       	subi	r30, 0xB9	; 185
 360:	fe 4f       	sbci	r31, 0xFE	; 254
 362:	91 83       	std	Z+1, r25	; 0x01
 364:	80 83       	st	Z, r24
 366:	80 e0       	ldi	r24, 0x00	; 0
 368:	90 91 46 01 	lds	r25, 0x0146	; 0x800146 <task_count>
 36c:	89 17       	cp	r24, r25
 36e:	90 f4       	brcc	.+36     	; 0x394 <rtos_scheduler_update+0x4a>
 370:	94 e0       	ldi	r25, 0x04	; 4
 372:	89 9f       	mul	r24, r25
 374:	f0 01       	movw	r30, r0
 376:	11 24       	eor	r1, r1
 378:	e9 5b       	subi	r30, 0xB9	; 185
 37a:	fe 4f       	sbci	r31, 0xFE	; 254
 37c:	22 81       	ldd	r18, Z+2	; 0x02
 37e:	33 81       	ldd	r19, Z+3	; 0x03
 380:	23 2b       	or	r18, r19
 382:	31 f0       	breq	.+12     	; 0x390 <rtos_scheduler_update+0x46>
 384:	22 81       	ldd	r18, Z+2	; 0x02
 386:	33 81       	ldd	r19, Z+3	; 0x03
 388:	21 50       	subi	r18, 0x01	; 1
 38a:	31 09       	sbc	r19, r1
 38c:	33 83       	std	Z+3, r19	; 0x03
 38e:	22 83       	std	Z+2, r18	; 0x02
 390:	8f 5f       	subi	r24, 0xFF	; 255
 392:	ea cf       	rjmp	.-44     	; 0x368 <rtos_scheduler_update+0x1e>
 394:	80 91 45 01 	lds	r24, 0x0145	; 0x800145 <current_task_index>
 398:	8f 5f       	subi	r24, 0xFF	; 255
 39a:	90 91 46 01 	lds	r25, 0x0146	; 0x800146 <task_count>
 39e:	89 17       	cp	r24, r25
 3a0:	08 f0       	brcs	.+2      	; 0x3a4 <rtos_scheduler_update+0x5a>
 3a2:	80 e0       	ldi	r24, 0x00	; 0
 3a4:	24 e0       	ldi	r18, 0x04	; 4
 3a6:	82 9f       	mul	r24, r18
 3a8:	f0 01       	movw	r30, r0
 3aa:	11 24       	eor	r1, r1
 3ac:	e9 5b       	subi	r30, 0xB9	; 185
 3ae:	fe 4f       	sbci	r31, 0xFE	; 254
 3b0:	22 81       	ldd	r18, Z+2	; 0x02
 3b2:	33 81       	ldd	r19, Z+3	; 0x03
 3b4:	23 2b       	or	r18, r19
 3b6:	19 f4       	brne	.+6      	; 0x3be <rtos_scheduler_update+0x74>
 3b8:	80 93 45 01 	sts	0x0145, r24	; 0x800145 <current_task_index>
 3bc:	04 c0       	rjmp	.+8      	; 0x3c6 <rtos_scheduler_update+0x7c>
 3be:	90 91 45 01 	lds	r25, 0x0145	; 0x800145 <current_task_index>
 3c2:	89 13       	cpse	r24, r25
 3c4:	e9 cf       	rjmp	.-46     	; 0x398 <rtos_scheduler_update+0x4e>
 3c6:	e0 91 45 01 	lds	r30, 0x0145	; 0x800145 <current_task_index>
 3ca:	84 e0       	ldi	r24, 0x04	; 4
 3cc:	e8 9f       	mul	r30, r24
 3ce:	f0 01       	movw	r30, r0
 3d0:	11 24       	eor	r1, r1
 3d2:	e9 5b       	subi	r30, 0xB9	; 185
 3d4:	fe 4f       	sbci	r31, 0xFE	; 254
 3d6:	80 81       	ld	r24, Z
 3d8:	91 81       	ldd	r25, Z+1	; 0x01
 3da:	90 93 58 03 	sts	0x0358, r25	; 0x800358 <current_sp+0x1>
 3de:	80 93 57 03 	sts	0x0357, r24	; 0x800357 <current_sp>
 3e2:	08 95       	ret

000003e4 <__vector_14>:
 3e4:	0f 92       	push	r0
 3e6:	0f b6       	in	r0, 0x3f	; 63
 3e8:	0f 92       	push	r0
 3ea:	1f 92       	push	r1
 3ec:	11 24       	eor	r1, r1
 3ee:	2f 92       	push	r2
 3f0:	3f 92       	push	r3
 3f2:	4f 92       	push	r4
 3f4:	5f 92       	push	r5
 3f6:	6f 92       	push	r6
 3f8:	7f 92       	push	r7
 3fa:	8f 92       	push	r8
 3fc:	9f 92       	push	r9
 3fe:	af 92       	push	r10
 400:	bf 92       	push	r11
 402:	cf 92       	push	r12
 404:	df 92       	push	r13
 406:	ef 92       	push	r14
 408:	ff 92       	push	r15
 40a:	0f 93       	push	r16
 40c:	1f 93       	push	r17
 40e:	2f 93       	push	r18
 410:	3f 93       	push	r19
 412:	4f 93       	push	r20
 414:	5f 93       	push	r21
 416:	6f 93       	push	r22
 418:	7f 93       	push	r23
 41a:	8f 93       	push	r24
 41c:	9f 93       	push	r25
 41e:	af 93       	push	r26
 420:	bf 93       	push	r27
 422:	cf 93       	push	r28
 424:	df 93       	push	r29
 426:	ef 93       	push	r30
 428:	ff 93       	push	r31
 42a:	ad b7       	in	r26, 0x3d	; 61
 42c:	be b7       	in	r27, 0x3e	; 62
 42e:	a0 93 57 03 	sts	0x0357, r26	; 0x800357 <current_sp>
 432:	b0 93 58 03 	sts	0x0358, r27	; 0x800358 <current_sp+0x1>
 436:	0e 94 a5 01 	call	0x34a	; 0x34a <rtos_scheduler_update>
 43a:	a0 91 57 03 	lds	r26, 0x0357	; 0x800357 <current_sp>
 43e:	b0 91 58 03 	lds	r27, 0x0358	; 0x800358 <current_sp+0x1>
 442:	ad bf       	out	0x3d, r26	; 61
 444:	be bf       	out	0x3e, r27	; 62
 446:	ff 91       	pop	r31
 448:	ef 91       	pop	r30
 44a:	df 91       	pop	r29
 44c:	cf 91       	pop	r28
 44e:	bf 91       	pop	r27
 450:	af 91       	pop	r26
 452:	9f 91       	pop	r25
 454:	8f 91       	pop	r24
 456:	7f 91       	pop	r23
 458:	6f 91       	pop	r22
 45a:	5f 91       	pop	r21
 45c:	4f 91       	pop	r20
 45e:	3f 91       	pop	r19
 460:	2f 91       	pop	r18
 462:	1f 91       	pop	r17
 464:	0f 91       	pop	r16
 466:	ff 90       	pop	r15
 468:	ef 90       	pop	r14
 46a:	df 90       	pop	r13
 46c:	cf 90       	pop	r12
 46e:	bf 90       	pop	r11
 470:	af 90       	pop	r10
 472:	9f 90       	pop	r9
 474:	8f 90       	pop	r8
 476:	7f 90       	pop	r7
 478:	6f 90       	pop	r6
 47a:	5f 90       	pop	r5
 47c:	4f 90       	pop	r4
 47e:	3f 90       	pop	r3
 480:	2f 90       	pop	r2
 482:	1f 90       	pop	r1
 484:	0f 90       	pop	r0
 486:	0f be       	out	0x3f, r0	; 63
 488:	0f 90       	pop	r0
 48a:	18 95       	reti

0000048c <uart_init>:
 48c:	9b 01       	movw	r18, r22
 48e:	ac 01       	movw	r20, r24
 490:	60 e4       	ldi	r22, 0x40	; 64
 492:	72 e4       	ldi	r23, 0x42	; 66
 494:	8f e0       	ldi	r24, 0x0F	; 15
 496:	90 e0       	ldi	r25, 0x00	; 0
 498:	0e 94 7a 02 	call	0x4f4	; 0x4f4 <__udivmodsi4>
 49c:	21 50       	subi	r18, 0x01	; 1
 49e:	31 09       	sbc	r19, r1
 4a0:	30 93 c5 00 	sts	0x00C5, r19	; 0x8000c5 <__TEXT_REGION_LENGTH__+0x7f80c5>
 4a4:	20 93 c4 00 	sts	0x00C4, r18	; 0x8000c4 <__TEXT_REGION_LENGTH__+0x7f80c4>
 4a8:	88 e1       	ldi	r24, 0x18	; 24
 4aa:	80 93 c1 00 	sts	0x00C1, r24	; 0x8000c1 <__TEXT_REGION_LENGTH__+0x7f80c1>
 4ae:	8e e0       	ldi	r24, 0x0E	; 14
 4b0:	80 93 c2 00 	sts	0x00C2, r24	; 0x8000c2 <__TEXT_REGION_LENGTH__+0x7f80c2>
 4b4:	08 95       	ret

000004b6 <uart_putc>:
 4b6:	90 91 c0 00 	lds	r25, 0x00C0	; 0x8000c0 <__TEXT_REGION_LENGTH__+0x7f80c0>
 4ba:	95 ff       	sbrs	r25, 5
 4bc:	fc cf       	rjmp	.-8      	; 0x4b6 <uart_putc>
 4be:	80 93 c6 00 	sts	0x00C6, r24	; 0x8000c6 <__TEXT_REGION_LENGTH__+0x7f80c6>
 4c2:	08 95       	ret

000004c4 <uart_print>:
 4c4:	cf 93       	push	r28
 4c6:	df 93       	push	r29
 4c8:	ec 01       	movw	r28, r24
 4ca:	89 91       	ld	r24, Y+
 4cc:	88 23       	and	r24, r24
 4ce:	19 f0       	breq	.+6      	; 0x4d6 <uart_print+0x12>
 4d0:	0e 94 5b 02 	call	0x4b6	; 0x4b6 <uart_putc>
 4d4:	fa cf       	rjmp	.-12     	; 0x4ca <uart_print+0x6>
 4d6:	df 91       	pop	r29
 4d8:	cf 91       	pop	r28
 4da:	08 95       	ret

000004dc <__udivmodqi4>:
 4dc:	99 1b       	sub	r25, r25
 4de:	79 e0       	ldi	r23, 0x09	; 9
 4e0:	04 c0       	rjmp	.+8      	; 0x4ea <__udivmodqi4_ep>

000004e2 <__udivmodqi4_loop>:
 4e2:	99 1f       	adc	r25, r25
 4e4:	96 17       	cp	r25, r22
 4e6:	08 f0       	brcs	.+2      	; 0x4ea <__udivmodqi4_ep>
 4e8:	96 1b       	sub	r25, r22

000004ea <__udivmodqi4_ep>:
 4ea:	88 1f       	adc	r24, r24
 4ec:	7a 95       	dec	r23
 4ee:	c9 f7       	brne	.-14     	; 0x4e2 <__udivmodqi4_loop>
 4f0:	80 95       	com	r24
 4f2:	08 95       	ret

000004f4 <__udivmodsi4>:
 4f4:	a1 e2       	ldi	r26, 0x21	; 33
 4f6:	1a 2e       	mov	r1, r26
 4f8:	aa 1b       	sub	r26, r26
 4fa:	bb 1b       	sub	r27, r27
 4fc:	fd 01       	movw	r30, r26
 4fe:	0d c0       	rjmp	.+26     	; 0x51a <__udivmodsi4_ep>

00000500 <__udivmodsi4_loop>:
 500:	aa 1f       	adc	r26, r26
 502:	bb 1f       	adc	r27, r27
 504:	ee 1f       	adc	r30, r30
 506:	ff 1f       	adc	r31, r31
 508:	a2 17       	cp	r26, r18
 50a:	b3 07       	cpc	r27, r19
 50c:	e4 07       	cpc	r30, r20
 50e:	f5 07       	cpc	r31, r21
 510:	20 f0       	brcs	.+8      	; 0x51a <__udivmodsi4_ep>
 512:	a2 1b       	sub	r26, r18
 514:	b3 0b       	sbc	r27, r19
 516:	e4 0b       	sbc	r30, r20
 518:	f5 0b       	sbc	r31, r21

0000051a <__udivmodsi4_ep>:
 51a:	66 1f       	adc	r22, r22
 51c:	77 1f       	adc	r23, r23
 51e:	88 1f       	adc	r24, r24
 520:	99 1f       	adc	r25, r25
 522:	1a 94       	dec	r1
 524:	69 f7       	brne	.-38     	; 0x500 <__udivmodsi4_loop>
 526:	60 95       	com	r22
 528:	70 95       	com	r23
 52a:	80 95       	com	r24
 52c:	90 95       	com	r25
 52e:	9b 01       	movw	r18, r22
 530:	ac 01       	movw	r20, r24
 532:	bd 01       	movw	r22, r26
 534:	cf 01       	movw	r24, r30
 536:	08 95       	ret

00000538 <malloc>:
 538:	0f 93       	push	r16
 53a:	1f 93       	push	r17
 53c:	cf 93       	push	r28
 53e:	df 93       	push	r29
 540:	82 30       	cpi	r24, 0x02	; 2
 542:	91 05       	cpc	r25, r1
 544:	10 f4       	brcc	.+4      	; 0x54a <malloc+0x12>
 546:	82 e0       	ldi	r24, 0x02	; 2
 548:	90 e0       	ldi	r25, 0x00	; 0
 54a:	e0 91 5b 03 	lds	r30, 0x035B	; 0x80035b <__flp>
 54e:	f0 91 5c 03 	lds	r31, 0x035C	; 0x80035c <__flp+0x1>
 552:	20 e0       	ldi	r18, 0x00	; 0
 554:	30 e0       	ldi	r19, 0x00	; 0
 556:	a0 e0       	ldi	r26, 0x00	; 0
 558:	b0 e0       	ldi	r27, 0x00	; 0
 55a:	30 97       	sbiw	r30, 0x00	; 0
 55c:	19 f1       	breq	.+70     	; 0x5a4 <malloc+0x6c>
 55e:	40 81       	ld	r20, Z
 560:	51 81       	ldd	r21, Z+1	; 0x01
 562:	02 81       	ldd	r16, Z+2	; 0x02
 564:	13 81       	ldd	r17, Z+3	; 0x03
 566:	48 17       	cp	r20, r24
 568:	59 07       	cpc	r21, r25
 56a:	c8 f0       	brcs	.+50     	; 0x59e <malloc+0x66>
 56c:	84 17       	cp	r24, r20
 56e:	95 07       	cpc	r25, r21
 570:	69 f4       	brne	.+26     	; 0x58c <malloc+0x54>
 572:	10 97       	sbiw	r26, 0x00	; 0
 574:	31 f0       	breq	.+12     	; 0x582 <malloc+0x4a>
 576:	12 96       	adiw	r26, 0x02	; 2
 578:	0c 93       	st	X, r16
 57a:	12 97       	sbiw	r26, 0x02	; 2
 57c:	13 96       	adiw	r26, 0x03	; 3
 57e:	1c 93       	st	X, r17
 580:	27 c0       	rjmp	.+78     	; 0x5d0 <malloc+0x98>
 582:	00 93 5b 03 	sts	0x035B, r16	; 0x80035b <__flp>
 586:	10 93 5c 03 	sts	0x035C, r17	; 0x80035c <__flp+0x1>
 58a:	22 c0       	rjmp	.+68     	; 0x5d0 <malloc+0x98>
 58c:	21 15       	cp	r18, r1
 58e:	31 05       	cpc	r19, r1
 590:	19 f0       	breq	.+6      	; 0x598 <malloc+0x60>
 592:	42 17       	cp	r20, r18
 594:	53 07       	cpc	r21, r19
 596:	18 f4       	brcc	.+6      	; 0x59e <malloc+0x66>
 598:	9a 01       	movw	r18, r20
 59a:	bd 01       	movw	r22, r26
 59c:	ef 01       	movw	r28, r30
 59e:	df 01       	movw	r26, r30
 5a0:	f8 01       	movw	r30, r16
 5a2:	db cf       	rjmp	.-74     	; 0x55a <malloc+0x22>
 5a4:	21 15       	cp	r18, r1
 5a6:	31 05       	cpc	r19, r1
 5a8:	f9 f0       	breq	.+62     	; 0x5e8 <malloc+0xb0>
 5aa:	28 1b       	sub	r18, r24
 5ac:	39 0b       	sbc	r19, r25
 5ae:	24 30       	cpi	r18, 0x04	; 4
 5b0:	31 05       	cpc	r19, r1
 5b2:	80 f4       	brcc	.+32     	; 0x5d4 <malloc+0x9c>
 5b4:	8a 81       	ldd	r24, Y+2	; 0x02
 5b6:	9b 81       	ldd	r25, Y+3	; 0x03
 5b8:	61 15       	cp	r22, r1
 5ba:	71 05       	cpc	r23, r1
 5bc:	21 f0       	breq	.+8      	; 0x5c6 <malloc+0x8e>
 5be:	fb 01       	movw	r30, r22
 5c0:	93 83       	std	Z+3, r25	; 0x03
 5c2:	82 83       	std	Z+2, r24	; 0x02
 5c4:	04 c0       	rjmp	.+8      	; 0x5ce <malloc+0x96>
 5c6:	90 93 5c 03 	sts	0x035C, r25	; 0x80035c <__flp+0x1>
 5ca:	80 93 5b 03 	sts	0x035B, r24	; 0x80035b <__flp>
 5ce:	fe 01       	movw	r30, r28
 5d0:	32 96       	adiw	r30, 0x02	; 2
 5d2:	44 c0       	rjmp	.+136    	; 0x65c <malloc+0x124>
 5d4:	fe 01       	movw	r30, r28
 5d6:	e2 0f       	add	r30, r18
 5d8:	f3 1f       	adc	r31, r19
 5da:	81 93       	st	Z+, r24
 5dc:	91 93       	st	Z+, r25
 5de:	22 50       	subi	r18, 0x02	; 2
 5e0:	31 09       	sbc	r19, r1
 5e2:	39 83       	std	Y+1, r19	; 0x01
 5e4:	28 83       	st	Y, r18
 5e6:	3a c0       	rjmp	.+116    	; 0x65c <malloc+0x124>
 5e8:	20 91 59 03 	lds	r18, 0x0359	; 0x800359 <__brkval>
 5ec:	30 91 5a 03 	lds	r19, 0x035A	; 0x80035a <__brkval+0x1>
 5f0:	23 2b       	or	r18, r19
 5f2:	41 f4       	brne	.+16     	; 0x604 <malloc+0xcc>
 5f4:	20 91 02 01 	lds	r18, 0x0102	; 0x800102 <__malloc_heap_start>
 5f8:	30 91 03 01 	lds	r19, 0x0103	; 0x800103 <__malloc_heap_start+0x1>
 5fc:	30 93 5a 03 	sts	0x035A, r19	; 0x80035a <__brkval+0x1>
 600:	20 93 59 03 	sts	0x0359, r18	; 0x800359 <__brkval>
 604:	20 91 00 01 	lds	r18, 0x0100	; 0x800100 <__DATA_REGION_ORIGIN__>
 608:	30 91 01 01 	lds	r19, 0x0101	; 0x800101 <__DATA_REGION_ORIGIN__+0x1>
 60c:	21 15       	cp	r18, r1
 60e:	31 05       	cpc	r19, r1
 610:	41 f4       	brne	.+16     	; 0x622 <malloc+0xea>
 612:	2d b7       	in	r18, 0x3d	; 61
 614:	3e b7       	in	r19, 0x3e	; 62
 616:	40 91 04 01 	lds	r20, 0x0104	; 0x800104 <__malloc_margin>
 61a:	50 91 05 01 	lds	r21, 0x0105	; 0x800105 <__malloc_margin+0x1>
 61e:	24 1b       	sub	r18, r20
 620:	35 0b       	sbc	r19, r21
 622:	e0 91 59 03 	lds	r30, 0x0359	; 0x800359 <__brkval>
 626:	f0 91 5a 03 	lds	r31, 0x035A	; 0x80035a <__brkval+0x1>
 62a:	e2 17       	cp	r30, r18
 62c:	f3 07       	cpc	r31, r19
 62e:	a0 f4       	brcc	.+40     	; 0x658 <malloc+0x120>
 630:	2e 1b       	sub	r18, r30
 632:	3f 0b       	sbc	r19, r31
 634:	28 17       	cp	r18, r24
 636:	39 07       	cpc	r19, r25
 638:	78 f0       	brcs	.+30     	; 0x658 <malloc+0x120>
 63a:	ac 01       	movw	r20, r24
 63c:	4e 5f       	subi	r20, 0xFE	; 254
 63e:	5f 4f       	sbci	r21, 0xFF	; 255
 640:	24 17       	cp	r18, r20
 642:	35 07       	cpc	r19, r21
 644:	48 f0       	brcs	.+18     	; 0x658 <malloc+0x120>
 646:	4e 0f       	add	r20, r30
 648:	5f 1f       	adc	r21, r31
 64a:	50 93 5a 03 	sts	0x035A, r21	; 0x80035a <__brkval+0x1>
 64e:	40 93 59 03 	sts	0x0359, r20	; 0x800359 <__brkval>
 652:	81 93       	st	Z+, r24
 654:	91 93       	st	Z+, r25
 656:	02 c0       	rjmp	.+4      	; 0x65c <malloc+0x124>
 658:	e0 e0       	ldi	r30, 0x00	; 0
 65a:	f0 e0       	ldi	r31, 0x00	; 0
 65c:	cf 01       	movw	r24, r30
 65e:	df 91       	pop	r29
 660:	cf 91       	pop	r28
 662:	1f 91       	pop	r17
 664:	0f 91       	pop	r16
 666:	08 95       	ret

00000668 <free>:
 668:	cf 93       	push	r28
 66a:	df 93       	push	r29
 66c:	00 97       	sbiw	r24, 0x00	; 0
 66e:	09 f4       	brne	.+2      	; 0x672 <free+0xa>
 670:	81 c0       	rjmp	.+258    	; 0x774 <free+0x10c>
 672:	fc 01       	movw	r30, r24
 674:	32 97       	sbiw	r30, 0x02	; 2
 676:	13 82       	std	Z+3, r1	; 0x03
 678:	12 82       	std	Z+2, r1	; 0x02
 67a:	a0 91 5b 03 	lds	r26, 0x035B	; 0x80035b <__flp>
 67e:	b0 91 5c 03 	lds	r27, 0x035C	; 0x80035c <__flp+0x1>
 682:	10 97       	sbiw	r26, 0x00	; 0
 684:	81 f4       	brne	.+32     	; 0x6a6 <free+0x3e>
 686:	20 81       	ld	r18, Z
 688:	31 81       	ldd	r19, Z+1	; 0x01
 68a:	82 0f       	add	r24, r18
 68c:	93 1f       	adc	r25, r19
 68e:	20 91 59 03 	lds	r18, 0x0359	; 0x800359 <__brkval>
 692:	30 91 5a 03 	lds	r19, 0x035A	; 0x80035a <__brkval+0x1>
 696:	28 17       	cp	r18, r24
 698:	39 07       	cpc	r19, r25
 69a:	51 f5       	brne	.+84     	; 0x6f0 <free+0x88>
 69c:	f0 93 5a 03 	sts	0x035A, r31	; 0x80035a <__brkval+0x1>
 6a0:	e0 93 59 03 	sts	0x0359, r30	; 0x800359 <__brkval>
 6a4:	67 c0       	rjmp	.+206    	; 0x774 <free+0x10c>
 6a6:	ed 01       	movw	r28, r26
 6a8:	20 e0       	ldi	r18, 0x00	; 0
 6aa:	30 e0       	ldi	r19, 0x00	; 0
 6ac:	ce 17       	cp	r28, r30
 6ae:	df 07       	cpc	r29, r31
 6b0:	40 f4       	brcc	.+16     	; 0x6c2 <free+0x5a>
 6b2:	4a 81       	ldd	r20, Y+2	; 0x02
 6b4:	5b 81       	ldd	r21, Y+3	; 0x03
 6b6:	9e 01       	movw	r18, r28
 6b8:	41 15       	cp	r20, r1
 6ba:	51 05       	cpc	r21, r1
 6bc:	f1 f0       	breq	.+60     	; 0x6fa <free+0x92>
 6be:	ea 01       	movw	r28, r20
 6c0:	f5 cf       	rjmp	.-22     	; 0x6ac <free+0x44>
 6c2:	d3 83       	std	Z+3, r29	; 0x03
 6c4:	c2 83       	std	Z+2, r28	; 0x02
 6c6:	40 81       	ld	r20, Z
 6c8:	51 81       	ldd	r21, Z+1	; 0x01
 6ca:	84 0f       	add	r24, r20
 6cc:	95 1f       	adc	r25, r21
 6ce:	c8 17       	cp	r28, r24
 6d0:	d9 07       	cpc	r29, r25
 6d2:	59 f4       	brne	.+22     	; 0x6ea <free+0x82>
 6d4:	88 81       	ld	r24, Y
 6d6:	99 81       	ldd	r25, Y+1	; 0x01
 6d8:	84 0f       	add	r24, r20
 6da:	95 1f       	adc	r25, r21
 6dc:	02 96       	adiw	r24, 0x02	; 2
 6de:	91 83       	std	Z+1, r25	; 0x01
 6e0:	80 83       	st	Z, r24
 6e2:	8a 81       	ldd	r24, Y+2	; 0x02
 6e4:	9b 81       	ldd	r25, Y+3	; 0x03
 6e6:	93 83       	std	Z+3, r25	; 0x03
 6e8:	82 83       	std	Z+2, r24	; 0x02
 6ea:	21 15       	cp	r18, r1
 6ec:	31 05       	cpc	r19, r1
 6ee:	29 f4       	brne	.+10     	; 0x6fa <free+0x92>
 6f0:	f0 93 5c 03 	sts	0x035C, r31	; 0x80035c <__flp+0x1>
 6f4:	e0 93 5b 03 	sts	0x035B, r30	; 0x80035b <__flp>
 6f8:	3d c0       	rjmp	.+122    	; 0x774 <free+0x10c>
 6fa:	e9 01       	movw	r28, r18
 6fc:	fb 83       	std	Y+3, r31	; 0x03
 6fe:	ea 83       	std	Y+2, r30	; 0x02
 700:	49 91       	ld	r20, Y+
 702:	59 91       	ld	r21, Y+
 704:	c4 0f       	add	r28, r20
 706:	d5 1f       	adc	r29, r21
 708:	ec 17       	cp	r30, r28
 70a:	fd 07       	cpc	r31, r29
 70c:	61 f4       	brne	.+24     	; 0x726 <free+0xbe>
 70e:	80 81       	ld	r24, Z
 710:	91 81       	ldd	r25, Z+1	; 0x01
 712:	84 0f       	add	r24, r20
 714:	95 1f       	adc	r25, r21
 716:	02 96       	adiw	r24, 0x02	; 2
 718:	e9 01       	movw	r28, r18
 71a:	99 83       	std	Y+1, r25	; 0x01
 71c:	88 83       	st	Y, r24
 71e:	82 81       	ldd	r24, Z+2	; 0x02
 720:	93 81       	ldd	r25, Z+3	; 0x03
 722:	9b 83       	std	Y+3, r25	; 0x03
 724:	8a 83       	std	Y+2, r24	; 0x02
 726:	e0 e0       	ldi	r30, 0x00	; 0
 728:	f0 e0       	ldi	r31, 0x00	; 0
 72a:	12 96       	adiw	r26, 0x02	; 2
 72c:	8d 91       	ld	r24, X+
 72e:	9c 91       	ld	r25, X
 730:	13 97       	sbiw	r26, 0x03	; 3
 732:	00 97       	sbiw	r24, 0x00	; 0
 734:	19 f0       	breq	.+6      	; 0x73c <free+0xd4>
 736:	fd 01       	movw	r30, r26
 738:	dc 01       	movw	r26, r24
 73a:	f7 cf       	rjmp	.-18     	; 0x72a <free+0xc2>
 73c:	8d 91       	ld	r24, X+
 73e:	9c 91       	ld	r25, X
 740:	11 97       	sbiw	r26, 0x01	; 1
 742:	9d 01       	movw	r18, r26
 744:	2e 5f       	subi	r18, 0xFE	; 254
 746:	3f 4f       	sbci	r19, 0xFF	; 255
 748:	82 0f       	add	r24, r18
 74a:	93 1f       	adc	r25, r19
 74c:	20 91 59 03 	lds	r18, 0x0359	; 0x800359 <__brkval>
 750:	30 91 5a 03 	lds	r19, 0x035A	; 0x80035a <__brkval+0x1>
 754:	28 17       	cp	r18, r24
 756:	39 07       	cpc	r19, r25
 758:	69 f4       	brne	.+26     	; 0x774 <free+0x10c>
 75a:	30 97       	sbiw	r30, 0x00	; 0
 75c:	29 f4       	brne	.+10     	; 0x768 <free+0x100>
 75e:	10 92 5c 03 	sts	0x035C, r1	; 0x80035c <__flp+0x1>
 762:	10 92 5b 03 	sts	0x035B, r1	; 0x80035b <__flp>
 766:	02 c0       	rjmp	.+4      	; 0x76c <free+0x104>
 768:	13 82       	std	Z+3, r1	; 0x03
 76a:	12 82       	std	Z+2, r1	; 0x02
 76c:	b0 93 5a 03 	sts	0x035A, r27	; 0x80035a <__brkval+0x1>
 770:	a0 93 59 03 	sts	0x0359, r26	; 0x800359 <__brkval>
 774:	df 91       	pop	r29
 776:	cf 91       	pop	r28
 778:	08 95       	ret

0000077a <_exit>:
 77a:	f8 94       	cli

0000077c <__stop_program>:
 77c:	ff cf       	rjmp	.-2      	; 0x77c <__stop_program>
