[org 0x7c00]                ; set location counter. also when you have assembler and linker in one step, tells linker where in physical memory to place to put code that follows (offset in segment)
[bits 16]                   ; we'll be in real mode which uses 16bit instructions. lets assembler know it needs to assemble instructions into 16 bit instructions.

; stack initialize
mov ax, 0x0
mov ss, ax ; cant assign a constant to ustack segment
mov sp, 0x7c00              ; stack pointer decreases (approaches 0)

; video memory
mov ax, 0xb800
mov es, ax

; print
mov byte [es:0], 'H'
mov byte [es:1], 0x0C
mov byte [es:2], 'E'
mov byte [es:3], 0x0D
mov byte [es:4], 'L'
mov byte [es:5], 0x0E
mov byte [es:6], 'L'
mov byte [es:7], 0x01
mov byte [es:8], 'O'
mov byte [es:9], 0x02
mov byte [es:0xa], ' '
mov byte [es:0xb], 0x03
mov byte [es:0xc], 'W'
mov byte [es:0xd], 0x03
mov byte [es:0xe], 'O'
mov byte [es:0xf], 0x04
mov byte [es:0x10], 'R'
mov byte [es:0x11], 0x05
mov byte [es:0x12], 'L'
mov byte [es:0x13], 0x06
mov byte [es:0x14], 'D'
mov byte [es:0x15], 0x08

loop:
    jmp loop

times   510 - ($-$$) db 0   ; $ current value of location counter
dw      0xaa55              ; necessary for BIOS to know this is bootable
