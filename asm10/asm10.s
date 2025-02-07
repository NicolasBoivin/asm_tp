section .bss
    result resb 32

section .text
global _start

_start:
    pop rcx
    cmp rcx, 4
    jne exit_error
    
    pop rcx         ; nom programme
    pop rsi         ; premier nombre
    call str_to_num
    mov rbx, rax    ; rbx = premier nombre
    
    pop rsi         ; deuxième nombre
    call str_to_num
    cmp rax, rbx    ; compare avec le plus grand actuel
    jle next
    mov rbx, rax    ; si plus grand, met à jour
    
next:
    pop rsi         ; troisième nombre
    call str_to_num
    cmp rax, rbx    ; compare avec le plus grand actuel
    jle print_result
    mov rbx, rax    ; si plus grand, met à jour
    
print_result:
    mov rdi, rbx
    call num_to_str
    
    mov rax, 60
    xor rdi, rdi
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

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall