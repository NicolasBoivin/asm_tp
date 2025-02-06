section .data
    message db "1337", 0

section .text
    global _start

_start:
    mov rdi, [rsp+8]
    test rdi, rdi
    jz exit_fail

    mov rsi, [rsp+8]
    movzx rdi, byte [rsi]   ; Charger le premier caractère de l'argument
    cmp rdi, '4'            ; Vérifier si c'est '4'
    jne exit_fail           ; Si ce n'est pas '4', sortir

    movzx rdi, byte [rsi+1] ; Charger le deuxième caractère
    cmp rdi, '2'            ; Vérifier si c'est '2'
    jne exit_fail           ; Si ce n'est pas '2', sortir

    mov rax, 1              ; syscall write
    mov rdi, 1              ; stdout
    mov rsi, message        ; Adresse de la chaîne "1337"
    mov rdx, 4              ; Taille de la chaîne
    syscall

    mov rax, 60             ; syscall exit
    xor rdi, rdi            ; Code de retour 0
    syscall

exit_fail:
    ; Quitter avec code 1
    mov rax, 60             ; syscall exit
    mov rdi, 1              ; Code de retour 1
    syscall
