section .text
    global _start

_start:
    mov     rax, [rsp]
    cmp     rax, 2
    jl      exit_fail_no_arg

    mov     rdi, [rsp+16]
    mov     rax, 2
    mov     rsi, 2
    syscall
    cmp     rax, 0
    js      exit_fail
    mov     r12, rax

    mov     rax, 0
    mov     rdi, r12
    mov     rsi, rsp
    mov     rdx, 4096
    syscall
    cmp     rax, 0
    jle     exit_fail

    mov     rbx, rsp
    mov     rcx, rax

find_loop:
    cmp     rcx, 4
    jl      exit_fail

    mov     eax, dword [rbx]
    cmp     eax, 0x37333331
    je      patch_value

    inc     rbx
    dec     rcx
    jmp     find_loop

patch_value:
    mov     dword [rbx], 0x4b433448

    mov     rax, 8
    mov     rdi, r12
    mov     rsi, 0
    mov     rdx, 0
    syscall

    mov     rax, 1
    mov     rdi, r12
    mov     rsi, rsp
    mov     rdx, 4096
    syscall

    mov     rax, 3
    mov     rdi, r12
    syscall

    mov     rax, 60
    xor     rdi, rdi
    syscall

exit_fail_no_arg:
    mov     rax, 60
    mov     rdi, 1
    syscall

exit_fail:
    mov     rax, 60
    mov     rdi, 1
    syscall
