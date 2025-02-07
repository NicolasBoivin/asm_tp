section .data
    message db "Hello Universe!", 10
    message_len equ $ - message

section .bss
    filename resb 256   ; Stocke le nom du fichier

section .text
global _start

_start:
    ; Vérifier le nombre d'arguments
    pop rdi
    cmp rdi, 2
    jne exit_error

    ; Récupérer le nom du fichier
    pop rsi  ; Ignorer le premier argument (nom du programme)
    pop rsi  ; Nom du fichier

    ; Ouvrir le fichier en mode écriture/création
    mov rax, 257        ; syscall: openat
    mov rdi, -100       ; AT_FDCWD (répertoire de travail actuel)
    mov rdx, 0x601      ; O_WRONLY | O_CREAT | O_TRUNC
    mov r10, 0644       ; Permissions rw-r--r--
    syscall
    cmp rax, 0
    js exit_error
    mov rdi, rax        ; Sauvegarde du descripteur de fichier

    ; Écrire le message dans le fichier
    mov rax, 1          ; syscall: write
    mov rsi, message    ; Adresse du message
    mov rdx, message_len ; Longueur du message
    syscall
    cmp rax, 0
    js exit_error

    ; Fermer le fichier
    mov rax, 3          ; syscall: close
    syscall

    ; Sortie avec succès
    mov rax, 60         ; syscall: exit
    xor rdi, rdi        ; code de retour 0
    syscall

exit_error:
    mov rax, 60         ; syscall: exit
    mov rdi, 1          ; code de retour 1
    syscall
