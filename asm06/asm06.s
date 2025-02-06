section .data
    newline db 10, 0

section .text
global _start

_start:
    pop rcx
    cmp rcx, 3
    jne exit_error
    
    pop rcx
    pop rsi
    pop rdi

    call str_to_int
    push rax
    mov rsi, rdi
    call str_to_int
    pop rdi
    add rax, rdi

    call int_to_str
    
    mov rax, 60
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall

str_to_int:
    xor rax, rax
    xor rcx, rcx
    xor r8, r8
    cmp byte [rsi], '-'
    jne next_digit
    mov r8, 1
    inc rsi
next_digit:
    movzx rdx, byte [rsi + rcx]
    test rdx, rdx
    jz str_to_int_done
    sub rdx, '0'
    mov rbx, 10
    imul rax, rbx
    add rax, rdx
    inc rcx
    jmp next_digit
str_to_int_done:
    test r8, r8
    jz positive
    neg rax
positive:
    ret

int_to_str:
    push rax
    mov r9, 10
    xor rcx, rcx
    
    test rax, rax
    jns positive_num
    neg rax
    push rax
    mov al, '-'
    push rax
    inc rcx
    pop rax
    pop rax
positive_num:
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
    mov rax, 1
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