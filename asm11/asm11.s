section .bss
    buffer resb 256  ; Stocke l'entrée utilisateur
    count resb 1     ; Stocke le nombre de voyelles

section .text
global _start

_start:
    ; Lire l'entrée utilisateur
    mov rax, 0       ; syscall: read
    mov rdi, 0       ; stdin
    mov rsi, buffer  ; Adresse de stockage
    mov rdx, 255     ; Taille max
    syscall
    
    ; Initialiser le compteur de voyelles
    xor rbx, rbx     ; count = 0
    
    mov rsi, buffer  ; Pointeur sur le buffer

count_vowels:
    movzx rcx, byte [rsi]  ; Charger le caractère actuel
    test rcx, rcx          ; Vérifier la fin de la chaîne (NULL ou newline)
    je print_result

    ; Vérifier si le caractère est une voyelle minuscule ou majuscule
    cmp rcx, 'a'
    je inc_count
    cmp rcx, 'e'
    je inc_count
    cmp rcx, 'i'
    je inc_count
    cmp rcx, 'o'
    je inc_count
    cmp rcx, 'u'
    je inc_count
    cmp rcx, 'y'
    je inc_count
    
    cmp rcx, 'A'
    je inc_count
    cmp rcx, 'E'
    je inc_count
    cmp rcx, 'I'
    je inc_count
    cmp rcx, 'O'
    je inc_count
    cmp rcx, 'U'
    je inc_count
    cmp rcx, 'Y'
    je inc_count
    
    jmp next_char

inc_count:
    inc rbx  ; Incrémenter le compteur

next_char:
    inc rsi  ; Passer au caractère suivant
    jmp count_vowels

print_result:
    mov rdi, rbx    ; Nombre de voyelles
    call num_to_str ; Convertir et afficher

    mov rax, 60     ; syscall: exit
    xor rdi, rdi    ; code de retour 0
    syscall

num_to_str:
    push rdi
    mov rsi, buffer
    add rsi, 31
    mov byte [rsi], 10
    pop rax
    mov rdi, 0
    test rax, rax
    jns .convert
    neg rax
    mov rdi, 1

.convert:
    mov rbx, 10

.next:
    dec rsi
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rsi], dl
    test rax, rax
    jnz .next

    test rdi, rdi
    jz .print
    dec rsi
    mov byte [rsi], '-'

.print:
    mov rax, 1
    mov rdi, 1
    mov rdx, buffer
    add rdx, 32
    sub rdx, rsi
    syscall
    ret
