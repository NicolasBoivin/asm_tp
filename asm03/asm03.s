section .data
    msg db '1337', 0Ah

section .bss
    input resb 3

section .text
    global _start

_start:
    mov rsi, input
    call read_input

    mov rsi, input
    mov rdi, msg
    call compare_strings

    cmp rax, 0
    je equal
    mov rdi, 1
    mov rsi, 1
    mov rdx, 0
    syscall
    jmp end

equal:
    mov rdi, 1
    mov rsi, msg
    mov rdx, 5
    mov rax, 0x1
    syscall

    mov rdi, 0
    mov rax, 60
    syscall

end:
    mov rdi, 1
    mov rax, 60
    syscall

read_input:
    mov rax, 0
    mov rdi, 0
    mov rdx, 3
    syscall
    ret

compare_strings:
    xor rax, rax
    xor rcx, rcx
.loop:
    mov al, byte [rsi + rcx]
    mov dl, byte [rdi + rcx]
    cmp al, dl
    jne .not_equal
    test al, al
    jz .equal
    inc rcx
    jmp .loop
.not_equal:
    mov rax, 1
    ret
.equal:
    ret
