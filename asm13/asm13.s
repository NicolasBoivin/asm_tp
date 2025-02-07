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
    je compare_strings
    mov al, [rsi]   ; Charger le caractère
    mov [rdi], al   ; Stocker dans le buffer inversé
    dec rsi         ; Reculer dans le buffer original
    inc rdi         ; Avancer dans le buffer inversé
    dec rcx         ; Décrémenter le compteur
    jmp reverse_loop

compare_strings:
    mov rcx, [length]
    mov rsi, buffer
    mov rdi, reversed

compare_loop:
    cmp rcx, 0
    je exit_success
    mov al, [rsi]
    cmp al, [rdi]
    jne exit_failure
    inc rsi
    inc rdi
    dec rcx
    jmp compare_loop

exit_success:
    mov rax, 60      ; syscall: exit
    xor rdi, rdi     ; code de retour 0
    syscall

exit_failure:
    mov rax, 60      ; syscall: exit
    mov rdi, 1       ; code de retour 1
    syscall