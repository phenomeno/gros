section .text
[bits 64]
    global _main
    extern _puts
    extern _printf
    extern _exit
_main:                ; this is called a label
    push rbp
    mov rbp, rsp

    mov ax, 0         ; initialize fibonacci seed values
    mov bx, 1
    mov rdx, 0        ; initialize loop counter

loop_start:
    cmp rdx, 30
    jge loop_end      ; jump greater equal
    push rdx

    push rbp
    mov rdi, fmt      ; x86-64 first parameter
    mov rsi, rdx
    call _printf
    pop rbp

    pop rdx
    add rdx, 1        ; advance dx
    jmp loop_start

loop_end:
    pop rbp
    ret

section .data
msg     db 'Hello World', 0
fmt     db 'Data: %x', 0xa, 0
