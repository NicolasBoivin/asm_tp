section .bss
    result resb 32

section .text
global _start

_start:
    pop rcx
    cmp rcx, 2
    jne exit_error
    
    pop rcx
    pop rsi
    call str_to_num
    
    cmp rax, -1
    je exit_error
    
    dec rax
    mov rcx, rax
    mov rbx, 0

sum_loop:
    cmp rcx, 0
    jle print_result
    add rbx, rcx
    dec rcx
    jmp sum_loop

print_result:
    mov rdi, rbx
    call num_to_str
    
    mov rax, 60
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall

str_to_num:
    xor rax, rax

.next:
    movzx rcx, byte [rsi]
    test rcx, rcx
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

num_to_str:
    mov rax, rdi
    mov rsi, result
    add rsi, 31
    mov byte [rsi], 10
    mov rbx, 10

.next:
    dec rsi
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rsi], dl
    test rax, rax
    jnz .next

    mov rax, 1
    mov rdi, 1
    mov rdx, result
    add rdx, 32
    sub rdx, rsi
    mov rax, 1
    syscall
    ret