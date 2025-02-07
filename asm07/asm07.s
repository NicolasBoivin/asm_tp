section .bss
    buffer resb 32
    number resq 1

section .text
global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 32
    syscall

    mov rsi, buffer
    call str_to_num

    cmp rax, -1
    je exit_error

    mov [number], rax

    mov rax, [number]
    cmp rax, 1
    jle not_prime

    mov rbx, 2

check_prime:
    mov rax, [number]
    cmp rbx, rax
    jge is_prime

    mov rax, [number]
    mov rdx, 0
    div rbx

    cmp rdx, 0
    je not_prime

    inc rbx
    jmp check_prime

is_prime:
    mov rax, 60
    xor rdi, rdi
    syscall

not_prime:
    mov rax, 60
    mov rdi, 1
    syscall

exit_error:
    mov rax, 60
    mov rdi, 2
    syscall

str_to_num:
    xor rax, rax

.next:
    movzx rcx, byte [rsi]
    cmp rcx, 10
    je .end
    cmp rcx, '0'
    jl .error
    cmp rcx, '9'
    jg .error

    sub rcx, '0'
    imul rax, 10
    add rax, rcx
    inc rsi
    jmp .next

.error:
    mov rax, -1
    ret

.end:
    ret