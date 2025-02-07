section .bss
    buffer resb 1024

section .data
    sockaddr resb 16
    timeout dq 1, 0

section .text
    global _start

_start:
    mov rax, 41
    mov rdi, 2
    mov rsi, 2
    mov rdx, 0
    syscall
    test rax, rax
    js error
    mov r12, rax

    mov word [sockaddr], 2
    mov word [sockaddr+2], 0x3905
    mov dword [sockaddr+4], 0x0100007F

    mov rax, 42
    mov rdi, r12
    mov rsi, sockaddr
    mov rdx, 16
    syscall
    test rax, rax
    js error

    mov rax, 44
    mov rdi, r12
    mov rsi, 0
    mov rdx, timeout
    mov r10, 8
    syscall
    test rax, rax
    js error

    mov rax, 0
    mov rdi, r12
    mov rsi, buffer
    mov rdx, 1024
    syscall
    test rax, rax
    jle timeout_exit

    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

timeout_exit:
    mov rax, 1
    mov rdi, 1
    syscall

error:
    mov rax, 60
    mov rdi, 1
    syscall
