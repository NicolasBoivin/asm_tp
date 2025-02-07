section .text
    global _start

_start:
    mov     rax, [rsp]
    cmp     rax, 2
    jl      exit_fail_no_arg

    mov     rdi, [rsp+16]
    mov     rax, 2
    mov     rsi, 0
    syscall
    cmp     rax, 0
    js      exit_fail
    mov     r12, rax

    mov     rax, 0
    mov     rdi, r12
    mov     rsi, rsp
    mov     rdx, 4
    syscall
    cmp     rax, 4
    jne     exit_fail

    mov     eax, dword [rsp]
    cmp     eax, 0x464c457f
    jne     exit_fail

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