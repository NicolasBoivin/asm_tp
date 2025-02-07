section .bss
    buffer resb 256

section .text
    global _start
    extern atoi

_start:
    mov rdi, [rsp+16]
    call atoi
    mov r12d, eax

    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 256
    syscall
    mov r13, rax

    mov rbx, 0
encode_loop:
    cmp rbx, r13
    jge end_encode

    mov al, [buffer+rbx]
    cmp al, 'a'
    jb skip
    cmp al, 'z'
    ja skip

    add al, r12b
    cmp al, 'z'
    jle store
    sub al, 26

store:
    mov [buffer+rbx], al

skip:
    inc rbx
    jmp encode_loop

end_encode:
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, r13
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall
