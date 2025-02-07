section .data
    pattern dd 0x37333331
    patch   dd 0x4B433448

section .bss
    window  resb 4
    temp    resb 1

section .text
    global _start

_start:
    mov     rax, [rsp]
    cmp     rax, 2
    jne     no_file_arg

    mov     rsi, [rsp+16]
    mov     rdi, -100
    mov     rdx, 2
    mov     r10, 0
    mov     rax, 257
    syscall
    cmp     rax, 0
    js      open_error
    mov     r12, rax

    mov     rax, 0
    mov     rdi, r12
    lea     rsi, [window]
    mov     rdx, 4
    syscall
    cmp     rax, 4
    jne     read_error

    mov     r13, 4
    mov     eax, dword [window]
    cmp     eax, [pattern]
    je      found_patch

search_loop:
    mov     rax, 0
    mov     rdi, r12
    lea     rsi, [temp]
    mov     rdx, 1
    syscall
    cmp     rax, 1
    jne     not_found

    inc     r13
    mov     al, byte [window+1]
    mov     byte [window], al
    mov     al, byte [window+2]
    mov     byte [window+1], al
    mov     al, byte [window+3]
    mov     byte [window+2], al
    mov     al, byte [temp]
    mov     byte [window+3], al

    mov     eax, dword [window]
    cmp     eax, [pattern]
    je      found_patch

    jmp     search_loop

found_patch:
    mov     rbx, r13
    sub     rbx, 4
    mov     rax, 8
    mov     rdi, r12
    mov     rsi, rbx
    xor     rdx, rdx
    syscall

    mov     rax, 1
    mov     rdi, r12
    lea     rsi, [patch]
    mov     rdx, 4
    syscall

    mov     rax, 3
    mov     rdi, r12
    syscall

    mov     rax, 60
    xor     rdi, rdi
    syscall

not_found:
    mov     rax, 3
    mov     rdi, r12
    syscall

    mov     rax, 60
    mov     rdi, 1
    syscall

read_error:
    mov     rax, 3
    mov     rdi, r12
    syscall

    mov     rax, 60
    mov     rdi, 1
    syscall

no_file_arg:
    mov     rax, 60
    mov     rdi, 1
    syscall

open_error:
    mov     rax, 60
    mov     rdi, 1
    syscall
