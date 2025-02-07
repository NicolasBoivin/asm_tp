section .bss
    buffer resb 256   ; Stocke l'entrée utilisateur
    reversed resb 256 ; Stocke la chaîne inversée
    length resb 1     ; Stocke la longueur de la chaîne

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
    cmp byte [rsi + rcx], 0   ; Vérifier la fin de la chaîne (sécurité)
    je reverse_string
    inc rcx
    jmp count_length

reverse_string:
    mov byte [length], cl  ; Stocker la longueur
    dec rcx  ; Ignorer le saut de ligne
    mov rsi, buffer
    add rsi, rcx  ; Pointeur sur le dernier caractère
    mov rdi, reversed  ; Pointeur sur le début du buffer inversé

reverse_loop:
    cmp rcx, -1
    je print_result
    mov al, [rsi]   ; Charger le caractère
    mov [rdi], al   ; Stocker dans le buffer inversé
    dec rsi         ; Reculer dans le buffer original
    inc rdi         ; Avancer dans le buffer inversé
    dec rcx         ; Décrémenter le compteur
    jmp reverse_loop

print_result:
    mov byte [rdi], 10  ; Ajouter un saut de ligne
    mov rax, 1       ; syscall: write
    mov rdi, 1       ; stdout
    mov rsi, reversed ; Adresse de la chaîne inversée
    movzx rdx, byte [length]
    inc rdx          ; Prendre en compte le saut de ligne
    syscall

    mov rax, 60      ; syscall: exit
    xor rdi, rdi     ; code de retour 0
    syscall
