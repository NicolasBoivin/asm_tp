global _start

section .text
_start:
    mov     rax, [rsp]
    cmp     rax, 2
    jb      exit_error

    mov     rbx, [rsp+16]
    test    rbx, rbx
    jz      exit_error

    xor     rcx, rcx
length_calc:
    mov     al, byte [rbx+rcx]
    cmp     al, 0
    je      length_done
    inc     rcx
    jmp     length_calc
length_done:
    test    rcx, rcx
    jz      exit_error
    mov     r12, rcx

    mov     rax, 9
    xor     rdi, rdi
    mov     rsi, r12
    mov     rdx, 7
    mov     r10, 0x22
    mov     r8, -1
    xor     r9, r9
    syscall
    test    rax, rax
    js      exit_error
    mov     r13, rax

    mov     rsi, rbx
    mov     rdi, r13
    mov     rcx, r12
    cld
    rep movsb

    lea     rax, [rel signal_action]
    mov     qword [rax], handler_routine
    
    mov     rax, 13
    mov     rdi, 11
    lea     rsi, [rel signal_action]
    xor     rdx, rdx
    mov     r10, 128
    syscall
    test    rax, rax
    js      exit_error

    mov     rax, 13
    mov     rdi, 4
    lea     rsi, [rel signal_action]
    xor     rdx, rdx
    mov     r10, 128
    syscall
    test    rax, rax
    js      exit_error

    jmp     r13

    mov     rax, 60
    xor     rdi, rdi
    syscall

exit_error:
    mov     rax, 60
    mov     rdi, 1
    syscall

handler_routine:
    mov     rax, 60
    mov     rdi, 1
    syscall

section .bss
    signal_action: resb 128