section .bss
    result resb 32

section .text
global _start

_start:
    pop rcx
    cmp rcx, 4
    jne exit_error
    
    pop rcx
    pop rsi
    call str_to_num
    mov rbx, rax
    
    pop rsi
    call str_to_num
    cmp rax, rbx
    jle next
    mov rbx, rax
    
next:
    pop rsi
    call str_to_num
    cmp rax, rbx
    jle print_result
    mov rbx, rax
    
print_result:
    mov rdi, rbx
    call num_to_str
    
    mov rax, 60
    xor rdi, rdi
    syscall

str_to_num:
    xor rax, rax
    xor r8, r8
    cmp byte [rsi], '-'
    jne .next
    mov r8, 1
    inc rsi

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
    test r8, r8
    jz .positive
    neg rax
.positive:
    ret

num_to_str:
    mov rax, rdi
    mov rsi, result
    add rsi, 31
    mov byte [rsi], 10
    
    test rax, rax
    jns .convert
    neg rax
    push rax
    mov al, '-'
    dec rsi
    mov [rsi], al
    pop rax

.convert:
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

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall