section .data
    msg db "Hello Universe!", 10
    msg_len equ $ - msg

section .text
global _start

_start:
    pop rdi
    cmp rdi, 2
    jne fail_exit

    pop rsi
    pop rsi

    mov rax, 2
    mov rdi, rsi
    mov rsi, 0x601
    mov rdx, 0644o
    syscall
    test rax, rax
    js fail_exit
    mov rdi, rax

    mov rax, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall
    test rax, rax
    js fail_exit

    mov rax, 3
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

fail_exit:
    mov rax, 60
    mov rdi, 1
    syscall
