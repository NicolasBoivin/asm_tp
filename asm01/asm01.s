section .data
    message db "1337", 0   ; Chaîne à afficher suivie d'un terminateur de chaîne (0).

section .text
    global _start

_start:
    mov rax, 1            ; numéro de l'appel système pour write (1)
    mov rdi, 1            ; le fichier de sortie standard (1 = stdout)
    mov rsi, message      ; adresse de la chaîne à afficher
    mov rdx, 4            ; longueur de la chaîne "1337" (4 caractères)
    syscall               ; appel système pour écrire

    ; Code de sortie du programme
    mov rax, 60           ; numéro de l'appel système pour exit (60)
    mov rdi, 1
    syscall               ; appel système pour quitter