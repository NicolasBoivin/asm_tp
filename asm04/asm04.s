section .bss
    input resb 3

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 3
    syscall

    movzx rdi, byte [input]
    sub rdi, '0'

    mov rax, rdi
    and rax, 1
    cmp rax, 0
    je even_number

    mov rax, 60
    mov rdi, 1
    syscall
    jmp end_program 

even_number:
    mov rax, 60
    mov rdi, 0
    syscall

end_program:
