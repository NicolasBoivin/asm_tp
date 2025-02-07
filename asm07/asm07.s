section .bss
    buffer resb 32  ; Réserve un buffer de 32 octets pour stocker l'entrée utilisateur
    number resq 1   ; Réserve un espace pour stocker le nombre converti

section .text
global _start

_start:
    ; Lire l'entrée utilisateur depuis STDIN
    mov rax, 0          ; Syscall read (0 = lecture)
    mov rdi, 0          ; Descripteur de fichier 0 (STDIN)
    mov rsi, buffer     ; Stocke l'entrée utilisateur dans 'buffer'
    mov rdx, 32         ; Lire jusqu'à 32 caractères
    syscall

    ; Convertir la chaîne entrée en un nombre
    mov rsi, buffer     ; Charger l'adresse du buffer (entrée utilisateur)
    call str_to_num     ; Appeler la fonction pour convertir en entier

    ; Vérifier si la conversion a échoué (entrée invalide)
    cmp rax, -1
    je exit_error       ; Si la conversion a échoué, quitter avec code 2

    mov [number], rax   ; Stocker le nombre converti dans la variable 'number'

    ; Vérifier si le nombre est <= 1 (car 1 et les négatifs ne sont pas premiers)
    mov rax, [number]
    cmp rax, 1
    jle not_prime       ; Si <= 1, ce n'est pas un nombre premier

    ; Initialisation pour la vérification de primalité
    mov rbx, 2          ; Commencer à tester la division avec 2

check_prime:
    mov rax, [number]   ; Charger le nombre à tester
    cmp rbx, rax        ; Si rbx >= nombre, on peut conclure que c'est un nombre premier
    jge is_prime

    ; Vérifier si 'number' est divisible par 'rbx'
    mov rax, [number]   ; Charger le nombre
    mov rdx, 0
    div rbx             ; RAX / RBX, le reste est dans RDX

    cmp rdx, 0          ; Vérifier si la division est exacte
    je not_prime        ; Si RDX == 0, alors 'number' est divisible par 'rbx', donc pas premier

    inc rbx             ; Incrémenter le diviseur pour tester le suivant
    jmp check_prime     ; Boucler jusqu'à prouver que c'est premier ou non

is_prime:
    ; Si on arrive ici, le nombre est premier
    mov rax, 60         ; Syscall exit
    xor rdi, rdi        ; Code de sortie 0 (nombre premier)
    syscall

not_prime:
    ; Si on arrive ici, le nombre n'est pas premier
    mov rax, 60         ; Syscall exit
    mov rdi, 1          ; Code de sortie 1 (nombre non premier)
    syscall

exit_error:
    ; Si on arrive ici, il y a eu une erreur (entrée invalide)
    mov rax, 60         ; Syscall exit
    mov rdi, 2          ; Code de sortie 2 (erreur d'entrée)
    syscall

; --- Fonction str_to_num (Convertit une chaîne ASCII en nombre entier) ---
str_to_num:
    xor rax, rax        ; Initialiser le résultat à 0

.next:
    movzx rcx, byte [rsi] ; Charger le caractère actuel
    cmp rcx, 10           ; Vérifier si c'est '\n' (fin de ligne)
    je .end
    cmp rcx, '0'
    jl .error             ; Si inférieur à '0', erreur
    cmp rcx, '9'
    jg .error             ; Si supérieur à '9', erreur

    sub rcx, '0'         ; Convertir le caractère ASCII en chiffre
    imul rax, 10         ; Multiplier le résultat précédent par 10
    add rax, rcx         ; Ajouter le chiffre courant au résultat
    inc rsi              ; Passer au prochain caractère
    jmp .next            ; Boucler jusqu'à la fin de la chaîne

.error:
    mov rax, -1          ; Indiquer une erreur de conversion
    ret

.end:
    ret