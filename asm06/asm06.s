section .bss
    result resb 20

section .text
    global _start

_start:
    pop rcx        ; nombre d'arguments
    cmp rcx, 3     ; vérifier si on a 2 arguments
    jne exit_error

    pop rcx        ; ignorer le nom du programme
    pop rsi        ; premier nombre
    call atoi      ; convertir en entier
    push rax       ; sauvegarder le résultat

    pop rsi        ; deuxième nombre
    call atoi
    pop rdi        ; récupérer le premier nombre
    add rax, rdi   ; addition

    mov rdi, rax   ; préparer pour itoa
    mov rsi, result
    call itoa

    mov rax, 1     ; afficher le résultat
    mov rdi, 1
    mov rsi, result
    mov rdx, rax
    syscall

    mov rax, 60    ; exit success
    xor rdi, rdi
    syscall

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall

atoi:
    xor rax, rax
.loop:
    movzx rcx, byte [rsi]
    test rcx, rcx
    jz .end
    cmp rcx, '0'
    jl .end
    cmp rcx, '9'
    jg .end
    sub rcx, '0'
    imul rax, 10
    add rax, rcx
    inc rsi
    jmp .loop
.end:
    ret

itoa:
    push rbx
    mov rbx, 10
    mov rcx, result
    add rcx, 19
    mov byte [rcx], 10
    mov rax, rdi
.loop:
    dec rcx
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rcx], dl
    test rax, rax
    jnz .loop
    mov rax, result
    add rax, 20
    sub rax, rcx
    mov rsi, rcx
    pop rbx
    ret