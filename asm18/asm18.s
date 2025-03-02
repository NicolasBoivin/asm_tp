global _start

section .text
_start:
    mov     rax, 41
    mov     rdi, 2
    mov     rsi, 2
    xor     rdx, rdx
    syscall
    cmp     rax, 0
    jl      socket_error
    mov     r15, rax

    mov     rax, 54
    mov     rdi, r15
    mov     rsi, 1
    mov     rdx, 20
    lea     r10, [rel timeout_config]
    mov     r8, 16
    syscall
    cmp     rax, 0
    jl      opt_error

    mov     rax, 44
    mov     rdi, r15
    lea     rsi, [rel request_data]
    mov     rdx, request_len
    xor     r10, r10
    lea     r8, [rel server_addr]
    mov     r9, 16
    syscall
    cmp     rax, 0
    jl      send_error

    sub     rsp, 1024
    mov     rax, 45
    mov     rdi, r15
    mov     rsi, rsp
    mov     rdx, 1024
    xor     r10, r10
    xor     r8, r8
    xor     r9, r9
    syscall
    cmp     rax, 0
    jl      receive_error

    mov     r14, rax

    mov     rax, 1
    mov     rdi, 1
    lea     rsi, [rel output_prefix]
    mov     rdx, prefix_len
    syscall

    mov     rax, 1
    mov     rdi, 1
    mov     rsi, rsp
    mov     rdx, r14
    syscall

    mov     rax, 1
    mov     rdi, 1
    lea     rsi, [rel output_suffix]
    mov     rdx, suffix_len
    syscall

    add     rsp, 1024

    mov     rax, 3
    mov     rdi, r15
    syscall

    mov     rax, 60
    xor     rdi, rdi
    syscall

socket_error:
    mov     rax, 1
    mov     rdi, 2
    lea     rsi, [rel error_socket]
    mov     rdx, socket_error_len
    syscall
    jmp     exit_failure

opt_error:
    mov     rax, 1
    mov     rdi, 2
    lea     rsi, [rel error_setsockopt]
    mov     rdx, setsockopt_error_len
    syscall
    jmp     exit_failure

send_error:
    mov     rax, 1
    mov     rdi, 2
    lea     rsi, [rel error_send]
    mov     rdx, send_error_len
    syscall
    jmp     exit_failure

receive_error:
    mov     rcx, rax
    cmp     rcx, -11
    je      timeout_handler

    mov     rax, 1
    mov     rdi, 2
    lea     rsi, [rel error_recv]
    mov     rdx, recv_error_len
    syscall
    jmp     exit_failure

timeout_handler:
    mov     rax, 1
    mov     rdi, 1
    lea     rsi, [rel timeout_notice]
    mov     rdx, timeout_len
    syscall
    jmp     exit_failure

exit_failure:
    mov     rax, 60
    mov     rdi, 1
    syscall

section .data
timeout_config:
    dq 1
    dq 0

server_addr:
    dw 2
    dw 0x3905
    dd 0x0100007F
    times 8 db 0

request_data:    db "Hello, server!",10
request_len:    equ $ - request_data

output_prefix: db 'message: "'
prefix_len: equ $ - output_prefix

output_suffix: db '"', 10
suffix_len: equ $ - output_suffix

error_socket:     db "Socket error",10
socket_error_len: equ $ - error_socket

error_setsockopt: db "Setsockopt error",10
setsockopt_error_len: equ $ - error_setsockopt

error_send:       db "Sendto error",10
send_error_len:  equ $ - error_send

error_recv:       db "Recvfrom error",10
recv_error_len:  equ $ - error_recv

timeout_notice:    db "Timeout: no response from server",10
timeout_len: equ $ - timeout_notice