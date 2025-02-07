section .data
    message db "Hello Universe!", 10
    message_len equ $ - message

section .bss
    filename resb 256   ; Stocke le nom du fichier

section .text
global _start

_start:
    ; Vérifier le nombre d'arguments
    pop rcx
    cmp rcx, 2
    jne exit_error

    ; Récupérer le nom du fichier
    pop rsi
    pop rsi  ; Ignorer le premier argument (nom du programme)

    ; Ouvrir le fichier en mode écriture/création
    mov rax, 2        ; syscall: open
    mov rdi, rsi      ; Nom du fichier
    mov rsi, 0x601    ; O_WRONLY | O_CREAT | O_TRUNC
    mov rdx, 0644o    ; Permissions rw-r--r--
    syscall
    cmp rax, 0
    jl exit_error
    mov rdi, rax      ; Sauvegarde du descripteur de fichier

    ; Écrire le message dans le fichier
    mov rax, 1        ; syscall: write
    mov rsi, message  ; Adresse du message
    mov rdx, message_len  ; Longueur du message
    syscall

    ; Fermer le fichier
    mov rax, 3        ; syscall: close
    syscall

    ; Sortie avec succès
    mov rax, 60      ; syscall: exit
    xor rdi, rdi     ; code de retour 0
    syscall

exit_error:
    mov rax, 60      ; syscall: exit
    mov rdi, 1       ; code de retour 1
    syscall
