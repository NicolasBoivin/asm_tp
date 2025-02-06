section .bss
    input resb 3

section .text
    global _start

_start:
    ; Lecture entrée
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 3
    syscall

    ; Conversion ASCII vers nombre
    movzx rax, byte [input]
    sub rax, '0'

    ; Cas spéciaux
    cmp rax, 2
    je is_prime
    cmp rax, 1
    jle not_prime
    
    ; Test si pair
    mov rdx, 0
    mov rbx, 2
    div rbx
    cmp rdx, 0
    je not_prime
    
    ; Test diviseurs impairs
    mov rcx, 3          ; diviseur actuel
check_loop:
    cmp rcx, rax
    jge is_prime
    
    mov rdx, 0
    mov rbx, rcx
    div rbx
    cmp rdx, 0
    je not_prime
    
    inc rcx
    inc rcx
    jmp check_loop

is_prime:
    mov rax, 60
    mov rdi, 0
    syscall

not_prime:
    mov rax, 60
    mov rdi, 1
    syscall