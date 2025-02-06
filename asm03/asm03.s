section .data
    msg db '1337', 10

section .text
global _start

_start:
    mov rdi, [rsp]
    cmp rdi, 2
    jne not_42

    mov rsi, [rsp + 16]

    cmp byte [rsi], '4'
    jne not_42
    cmp byte [rsi + 1], '2'
    jne not_42
    cmp byte [rsi + 2], 0
    jne not_42

    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, 5
    syscall

    mov rax, 60
    mov rdi, 0
    syscall

not_42:
    mov rax, 60
    mov rdi, 1
    syscall
