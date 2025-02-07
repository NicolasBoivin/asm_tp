section .bss
    buffer resb 256  ; Stocke l'entrée utilisateur
    length resb 1   ; Stocke la longueur de la chaîne

section .text
global _start

_start:
    ; Lire l'entrée utilisateur
    mov rax, 0       ; syscall: read
    mov rdi, 0       ; stdin
    mov rsi, buffer  ; Adresse de stockage
    mov rdx, 255     ; Taille max
    syscall
    
    ; Déterminer la longueur de la chaîne
    xor rcx, rcx
    mov rsi, buffer

count_length:
    cmp byte [rsi + rcx], 10  ; Vérifier le saut de ligne
    je reverse_string
    inc rcx
    jmp count_length

reverse_string:
    mov byte [length], cl  ; Stocker la longueur
    dec rcx  ; Ignorer le saut de ligne
    mov rdi, buffer
    add rdi, rcx  ; Pointeur sur la fin

print_reversed:
    cmp rcx, 0
    jl exit_program
    movzx rax, byte [rdi]
    mov byte [buffer + rcx], al  ; Stocker à la position correcte
    dec rdi
    dec rcx
    jmp print_reversed

exit_program:
    mov rax, 1       ; syscall: write
    mov rdi, 1       ; stdout
    mov rsi, buffer  ; Adresse de la chaîne inversée
    movzx rdx, byte [length]
    syscall

    mov rax, 60      ; syscall: exit
    xor rdi, rdi     ; code de retour 0
    syscall
