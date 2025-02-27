.section .data
    udp_port:    .word 0x3905          # Port 1337 en big-endian
    log_path:    .asciz "messages"     # Chemin du fichier de log
    start_msg:   .asciz "\n⏳ Listening on port 1337\n"
    line_end:    .asciz "\n"

.section .bss
    msg_buffer:  .skip 1024            # Espace pour les données entrantes
    addr_struct: .skip 16              # Structure sockaddr pour les opérations réseau

.section .text
    .global _start

_start:
    # Initialiser le socket (AF_INET, SOCK_DGRAM, 0)
    mov $41, %rax           # socket syscall
    mov $2, %rdi            # AF_INET
    mov $2, %rsi            # SOCK_DGRAM
    xor %rdx, %rdx          # Protocol = 0
    syscall
    test %rax, %rax
    js terminate            # Sortie si erreur
    mov %rax, %r15          # Conserver le socket dans r15

    # Configurer sockaddr_in
    movw $2, addr_struct    # AF_INET
    movw udp_port, %cx      # Port UDP
    movw %cx, addr_struct+2 # Placer le port dans la structure
    movl $0, addr_struct+4  # INADDR_ANY (toutes les interfaces)
    movq $0, addr_struct+8  # Padding à zéro

    # Bind socket à l'adresse et port
    mov $49, %rax           # bind syscall
    mov %r15, %rdi          # Socket FD
    lea addr_struct, %rsi   # Adresse de liaison
    mov $16, %rdx           # Taille de la structure
    syscall
    test %rax, %rax
    js terminate            # Sortie si erreur

    # Afficher message d'écoute
    mov $1, %rax            # write syscall
    mov $1, %rdi            # STDOUT
    lea start_msg, %rsi     # Message
    mov $24, %rdx           # Longueur
    syscall

listen_loop:
    # Attendre un message UDP
    mov $45, %rax           # recvfrom syscall
    mov %r15, %rdi          # Socket FD
    lea msg_buffer, %rsi    # Buffer de réception
    mov $1024, %rdx         # Taille max
    xor %r10, %r10          # Flags = 0
    lea addr_struct, %r8    # Client address
    mov $16, %r9            # Addrlen
    syscall
    test %rax, %rax
    js terminate            # Sortie si erreur
    mov %rax, %r14          # Sauvegarder longueur du message

    # Ouvrir fichier de log (append mode)
    mov $2, %rax            # open syscall
    lea log_path, %rdi      # Nom du fichier
    mov $0x441, %rsi        # O_WRONLY | O_APPEND | O_CREAT
    mov $0644, %rdx         # Permissions (-rw-r--r--)
    syscall
    test %rax, %rax
    js listen_loop          # Continuer même si échec d'ouverture
    mov %rax, %rbx          # Sauvegarder FD du fichier

    # Écrire le message dans le fichier
    mov $1, %rax            # write syscall
    mov %rbx, %rdi          # File descriptor
    lea msg_buffer, %rsi    # Buffer avec le message
    mov %r14, %rdx          # Longueur du message
    syscall

    # Ajouter une nouvelle ligne
    mov $1, %rax            # write syscall
    mov %rbx, %rdi          # File descriptor
    lea line_end, %rsi      # Caractère nouvelle ligne
    mov $1, %rdx            # Longueur 1
    syscall

    # Fermer le fichier
    mov $3, %rax            # close syscall
    mov %rbx, %rdi          # File descriptor
    syscall

    # Retourner en attente
    jmp listen_loop

terminate:
    # Fermer le socket si ouvert
    cmp $0, %r15
    jl exit
    mov $3, %rax            # close syscall
    mov %r15, %rdi          # Socket FD
    syscall

exit:
    mov $60, %rax           # exit syscall
    xor %rdi, %rdi          # Code retour 0
    syscall