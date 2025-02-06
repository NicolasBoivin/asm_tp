section .data
    space db " ", 0
    newline db 10, 0

section .text
global _start

_start:
    pop rcx         ; nombre d'arguments
    cmp rcx, 3      ; vérifier 2 arguments
    jne exit_error
    
    pop rcx         ; nom programme
    pop rsi         ; premier arg
    pop rdi         ; deuxième arg

    ; Convertir et additionner
    call str_to_int  ; rsi -> rax
    push rax
    mov rsi, rdi
    call str_to_int  ; rdi -> rax
    pop rdi
    add rax, rdi    ; addition

    ; Convertir en string et afficher
    call int_to_str
    
    mov rax, 60     ; exit success
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall

str_to_int:
    xor rax, rax
    xor rcx, rcx
    mov rbx, 10
next_digit:
    movzx rdx, byte [rsi + rcx]
    test rdx, rdx
    jz str_to_int_done
    sub rdx, '0'
    imul rax, rbx
    add rax, rdx
    inc rcx
    jmp next_digit
str_to_int_done:
    ret

int_to_str:
    push rax
    mov r9, 10
    xor rcx, rcx
    test rax, rax
    jnz .l1
    mov al, '0'
    push rax
    inc rcx
    jmp .l2
.l1:
    test rax, rax
    jz .l2
    xor rdx, rdx
    div r9
    add dl, '0'
    push rdx
    inc rcx
    jmp .l1
.l2:
    mov rax, 1      ; write
    mov rdi, 1
.l3:
    test rcx, rcx
    jz .l4
    mov rsi, rsp
    mov rdx, 1
    push rcx
    syscall
    pop rcx
    add rsp, 8
    dec rcx
    jmp .l3
.l4:
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    
    pop rax
    ret