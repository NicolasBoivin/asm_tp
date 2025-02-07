section .bss
    input resb 1024
    shift resb 1

section .text
global _start

_start:
    pop rcx
    cmp rcx, 2
    jne error
    pop rcx
    pop rdi
    xor rax, rax
    mov rsi, shift
    call atoi

read_input:
    xor rax, rax
    xor rdi, rdi
    mov rsi, input
    mov rdx, 1024
    syscall

    mov rcx, rax
    mov rsi, input
    xor rbx, rbx

process_char:
    cmp rbx, rcx
    jge write_output

    mov al, [rsi + rbx]

    cmp al, 'A'
    jl next_char
    cmp al, 'Z'
    jle upper_case
    cmp al, 'a'
    jl next_char
    cmp al, 'z'
    jg next_char

    mov dl, [shift]
    add al, dl
    cmp al, 'z'
    jle store_char
    sub al, 26
    jmp store_char

upper_case:
    mov dl, [shift]
    add al, dl
    cmp al, 'Z'
    jle store_char
    sub al, 26

store_char:
    mov [rsi + rbx], al

next_char:
    inc rbx
    jmp process_char

write_output:
    mov rax, 1
    mov rdi, 1
    mov rdx, rcx
    mov rsi, input
    syscall

    xor rdi, rdi
    jmp exit

error:
    mov rax, 60
    mov rdi, 1
    syscall

exit:
    mov rax, 60
    mov rdi, rdi
    syscall

atoi:
    xor rax, rax
convert_loop:
    movzx rcx, byte [rdi]
    cmp rcx, 0
    je atoi_end
    cmp rcx, '0'
    jl atoi_end
    cmp rcx, '9'
    jg atoi_end
    sub rcx, '0'
    imul rax, 10
    add rax, rcx
    inc rdi
    jmp convert_loop
atoi_end:
    mov [rsi], al
    ret