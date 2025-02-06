section .bss
    result resb 20

section .text
    global _start

_start:
    pop rcx         ; nombre d'arguments
    cmp rcx, 3      ; vérifier si on a 2 arguments
    jne exit_error

    pop rcx         ; ignorer le nom du programme
    pop rsi         ; premier nombre
    call atoi      
    push rax       

    pop rsi         ; deuxième nombre
    call atoi      
    push rax       

    pop rcx         ; second nombre
    pop rbx         ; premier nombre
    add rbx, rcx    ; addition

    mov rdi, rbx    ; préparer pour itoa
    call itoa

    mov rdi, 1      ; afficher le résultat
    mov rsi, result
    mov rdx, rax
    mov rax, 1
    syscall

    xor rdi, rdi    ; exit success
    mov rax, 60
    syscall

exit_error:
    mov rdi, 1
    mov rax, 60
    syscall

atoi:
    xor rax, rax    ; initialiser le résultat
    xor rbx, rbx    ; signe (0 = positif)
    
    cmp byte [rsi], '-'
    jne .loop
    mov rbx, 1      ; nombre négatif
    inc rsi
    
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
    test rbx, rbx
    jz .positive
    neg rax         ; si négatif, inverser le signe
.positive:
    ret

itoa:
    mov rax, rdi
    mov rcx, result
    add rcx, 19
    mov byte [rcx], 10  ; newline
    
    test rax, rax
    jns .positive
    
    neg rax         ; si négatif, rendre positif
    push rax
    mov byte [result], '-'
    pop rax
    
.positive:
    mov rbx, 10
    
.loop:
    dec rcx
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rcx], dl
    test rax, rax
    jnz .loop
    
    test rdi, rdi   ; vérifier si le nombre était négatif
    jns .end
    dec rcx
    mov byte [rcx], '-'
    
.end:
    mov rax, result
    add rax, 20
    sub rax, rcx
    mov rsi, rcx
    ret