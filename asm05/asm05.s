section .text
    global _start

_start:
    mov rdi, [rsp + 8]
    mov rax, 1
    mov rsi, rdi
    mov rdx, 16
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall
