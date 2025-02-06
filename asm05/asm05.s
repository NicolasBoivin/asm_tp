section .text
global _start

_start:
    pop rcx
    cmp rcx, 2
    jl exit
    
    pop rcx
    pop rsi
    
    mov rdx, 0
str_len:
    cmp byte [rsi + rdx], 0
    je print
    inc rdx
    jmp str_len
    
print:
    mov rax, 1
    mov rdi, 1
    syscall
    
    mov rax, 60
    mov rdi, 0
    syscall

exit:
    mov rax, 60
    mov rdi, 1
    syscall