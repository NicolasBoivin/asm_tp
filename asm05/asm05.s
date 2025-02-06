section .text
    global _start

_start:
    cmp rdi, 1
    je no_param

    mov rdi, [rsp + 8]
    mov rax, 1
    mov rsi, rdi
    mov rdx, 16
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

no_param:
    mov rax, 60
    mov rdi, 1
    syscall
