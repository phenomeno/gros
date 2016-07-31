section .text
[bits 64]
  global _main
  extern _printf

_main:
  push rbp
  mov rbp, rsp
  sub rsp, 32
  mov DWORD [rbp-4], 0
  mov DWORD [rbp-8], 1
  mov DWORD [rbp-16], 0

loop_start:
  mov edx, DWORD [rbp-16]
  cmp edx, 100
  jge loop_end
  cmp edx, 1
  jg meat
  mov rdi, fmt
  mov esi, edx
  call _printf
  mov edx, DWORD [rbp-16]
  inc edx
  mov DWORD [rbp-16], edx
  jmp loop_start

loop_end:
  add rsp, 32
  pop rbp ;rbp value is set to old value
  mov rax, 0 ;return value is stored in rax
  ret

meat:
  mov eax, [rbp-4]
  mov ebx, [rbp-8]
  add eax, ebx
  mov [rbp-12], eax
  mov [rbp-8], eax
  mov [rbp-4], ebx
  add edx, 1
  mov [rbp-16], edx
  mov rdi, fmt
  mov esi, eax
  call _printf
  jmp loop_start

section .data
fmt db '#: %ld', 0xa, 0 ;0xa is linefeed, 0 null
