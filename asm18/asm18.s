section .bss
    buffer resb 1024

section .data
    sockaddr resb 16
    timeout dq 1, 0
    msg db "Timeout: no response from server", 10, 0
    hello_msg db "Hello, client!", 10, 0
    request_msg db "PING", 4

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

    mov rax, 44
    mov rdi, r12
    mov rsi, request_msg
    mov rdx, 4
    mov r10, sockaddr
    mov r8, 16
    syscall
    test rax, rax
    js error

    mov rax, 23
    mov rdi, r12
    mov rsi, 0
    mov rdx, timeout
    mov r10, 0
    syscall

    mov rax, 45
    mov rdi, r12
    mov rsi, buffer
    mov rdx, 1024
    mov r10, 0
    mov r8, 0
    syscall
    test rax, rax
    jle timeout_exit

    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    syscall

    cmp rdx, 0
    je timeout_exit

    mov rax, 1
    mov rdi, 1
    mov rsi, hello_msg
    mov rdx, 14
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

timeout_exit:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, 31
    syscall
    mov rax, 60
    mov rdi, 1
    syscall

error:
    mov rax, 60
    mov rdi, 1
    syscall
