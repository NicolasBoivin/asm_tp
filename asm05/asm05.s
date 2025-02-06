section .data
    msg db 'Hello, Universe!', 0

section .text
    global _start

_start:
    cmp qword [rsp + 8], 0
    je no_param

    mov rdi, [rsp + 8]
    mov rax, 1
    mov rsi, rdi
    mov rdx, 15
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

no_param:
    mov rax, 60
    mov rdi, 1
    syscall
