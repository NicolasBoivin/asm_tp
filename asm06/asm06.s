section .bss
    num resb 32
    
section .data
    minus db '-'
    newline db 10

section .text
global _start

_start:
    pop rcx         ; nombre d'arguments
    cmp rcx, 3
    jne exit_error
    
    pop rcx         ; nom programme
    pop rsi         ; premier nombre
    call atoi
    mov r8, rax     ; sauvegarde premier nombre
    
    pop rsi         ; deuxième nombre
    call atoi
    add rax, r8     ; addition
    
    mov rdi, rax    ; prépare pour conversion
    mov rsi, num
    call itoa
    
    mov rax, 60     ; exit success
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall

atoi:
    xor rax, rax
    xor rcx, rcx        ; rcx = 0 (positif)
    cmp byte [rsi], '-'
    jne .conv
    mov rcx, 1          ; rcx = 1 (négatif)
    inc rsi
.conv:
    xor rbx, rbx
.next:
    movzx rdx, byte [rsi]
    test rdx, rdx
    jz .done
    sub rdx, '0'
    imul rbx, 10
    add rbx, rdx
    inc rsi
    jmp .next
.done:
    mov rax, rbx
    test rcx, rcx
    jz .pos
    neg rax
.pos:
    ret

itoa:
    test rdi, rdi       ; test si négatif
    jns .positive
    push rdi
    mov rax, 1          ; affiche '-'
    mov rdi, 1
    mov rsi, minus
    mov rdx, 1
    syscall
    pop rdi
    neg rdi            ; rend positif
.positive:
    mov rax, rdi
    mov rsi, num
    add rsi, 31
    mov byte [rsi], 10  ; newline à la fin
    mov rbx, 10
.next:
    dec rsi
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rsi], dl
    test rax, rax
    jnz .next
    
    mov rax, 1          ; affiche le nombre
    mov rdi, 1
    mov rdx, num
    add rdx, 32
    sub rdx, rsi
    mov rax, 1
    syscall
    ret