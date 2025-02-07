section .data
    message     db "Hello Universe!"
    message_len equ $ - message

section .text
global _start

_start:
    mov     rax, [rsp]
    cmp     rax, 2
    jl      exit_fail_no_arg

    mov     rbx, [rsp+16]

    mov     rax, 257
    mov     rdi, -100
    mov     rsi, rbx
    mov     rdx, 577
    mov     r10, 420
    syscall
    cmp     rax, 0
    js      exit_fail
    mov     r12, rax

    mov     rax, 1
    mov     rdi, r12
    mov     rsi, message
    mov     rdx, message_len
    syscall

    mov     rax, 3
    mov     rdi, r12
    syscall

    mov     rax, 60
    xor     rdi, rdi
    syscall

exit_fail_no_arg:
    mov     rax, 60
    mov     rdi, 1
    syscall

exit_fail:
    mov     rax, 60
    mov     rdi, 1
    syscall
