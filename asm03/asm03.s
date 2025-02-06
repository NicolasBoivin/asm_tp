section .data
    message db "1337", 0

section .text
    global _start

_start:
    ; Vérifier si un argument est passé
    mov rdi, [rsp+8]         ; Le premier argument passé en paramètre
    test rdi, rdi
    jz exit_fail             ; Si aucun argument, sortir avec code 1

    ; Comparer l'argument avec "42"
    mov rsi, rdi
    movzx rdi, byte [rsi]    ; Charger le premier caractère de l'argument
    cmp rdi, '4'
    jne exit_fail            ; Si ce n'est pas "4", sortir avec code 1
    movzx rdi, byte [rsi+1]  ; Charger le deuxième caractère
    cmp rdi, '2'
    jne exit_fail            ; Si ce n'est pas "2", sortir avec code 1

    ; Afficher "1337"
    mov rax, 1
    mov rdi, 1
    mov rsi, message
    mov rdx, 4
    syscall

    ; Sortie avec code 0
    mov rax, 60
    xor rdi, rdi
    syscall

exit_fail:
    ; Sortie avec code 1
    mov rax, 60
    mov rdi, 1
    syscall
