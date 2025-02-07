section .data
    hex_chars db "0123456789ABCDEF"
    newline db 10

section .bss
    result resb 32

section .text
global _start

_start:
    pop rcx
    cmp rcx, 3
    je decimal_to_hex
    cmp rcx, 4
    je check_binary
    jmp exit_error

check_binary:
    pop rcx
    pop rsi
    cmp byte [rsi], '-'
    jne exit_error
    cmp byte [rsi + 1], 'b'
    jne exit_error
    jmp decimal_to_binary

decimal_to_hex:
    pop rcx
    pop rsi
    call str_to_num
    mov rdi, rax
    call convert_to_hex
    jmp end_success

decimal_to_binary:
    pop rsi
    call str_to_num
    mov rdi, rax
    call convert_to_binary
    jmp end_success

convert_to_hex:
    mov rax, rdi
    mov rsi, result
    add rsi, 31
    mov byte [rsi], 10
    mov rbx, 16

.next:
    dec rsi
    xor rdx, rdx
    div rbx
    movzx rcx, byte [hex_chars + rdx]
    mov [rsi], cl
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

convert_to_binary:
    mov rax, rdi
    mov rsi, result
    add rsi, 31
    mov byte [rsi], 10
    mov rbx, 2

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

end_success:
    mov rax, 60
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall