.section .data
msg_prefix:
    .ascii "message: \""
msg_prefix_len = . - msg_prefix

msg_suffix:
    .ascii "\"\n"
msg_suffix_len = . - msg_suffix

err_timeout:
    .ascii "Timeout: no response from server\n"
err_timeout_len = . - err_timeout

request_data:
    .ascii "ping"
request_len = . - request_data

server_addr:
    .word 2                  # AF_INET
    .word 0x3905             # Port 1337 (network byte order)
    .long 0x0100007f         # 127.0.0.1 (network byte order)
    .quad 0                  # Padding

wait_time:
    .quad 1                  # 1 second
    .quad 0                  # 0 nanoseconds

    .section .bss
    .lcomm buffer, 256       # Buffer pour la réponse

    .section .text
    .global _start
_start:
    # Créer socket UDP
    mov     $41, %rax        # socket syscall
    mov     $2, %rdi         # AF_INET
    mov     $2, %rsi         # SOCK_DGRAM
    xor     %rdx, %rdx       # Protocol = 0
    syscall
    cmp     $0, %rax
    jl      error_exit
    mov     %rax, %rbx       # Sauvegarder le descripteur dans %rbx

    # Configurer le timeout
    mov     %rbx, %rdi       # Socket FD
    mov     $1, %rsi         # SOL_SOCKET
    mov     $20, %rdx        # SO_RCVTIMEO
    lea     wait_time(%rip), %r10
    mov     $16, %r8         # Taille de timeval
    mov     $54, %rax        # setsockopt syscall
    syscall

    # Envoyer données
    mov     %rbx, %rdi       # Socket FD
    lea     request_data(%rip), %rsi
    mov     $request_len, %rdx
    xor     %r10, %r10       # Flags = 0
    lea     server_addr(%rip), %r8
    mov     $16, %r9         # Taille de l'adresse
    mov     $44, %rax        # sendto syscall
    syscall

    # Recevoir la réponse
    mov     %rbx, %rdi       # Socket FD
    lea     buffer(%rip), %rsi
    mov     $256, %rdx       # Taille max du buffer
    xor     %r10, %r10       # Flags = 0
    xor     %r8, %r8         # Adresse source NULL
    xor     %r9, %r9         # Taille adresse source = 0
    mov     $45, %rax        # recvfrom syscall
    syscall
    cmp     $0, %rax
    jl      handle_timeout
    mov     %rax, %r12       # Sauvegarder la taille reçue

    # Afficher le préfixe
    mov     $1, %rdi         # STDOUT
    lea     msg_prefix(%rip), %rsi
    mov     $msg_prefix_len, %rdx
    mov     $1, %rax         # write syscall
    syscall

    # Afficher la réponse
    mov     $1, %rdi         # STDOUT
    lea     buffer(%rip), %rsi
    mov     %r12, %rdx       # Taille de la réponse
    mov     $1, %rax         # write syscall
    syscall

    # Afficher le suffixe
    mov     $1, %rdi         # STDOUT
    lea     msg_suffix(%rip), %rsi
    mov     $msg_suffix_len, %rdx
    mov     $1, %rax         # write syscall
    syscall

    # Fermer le socket
    mov     %rbx, %rdi
    mov     $3, %rax         # close syscall
    syscall

    # Exit avec code 0
    mov     $60, %rax        # exit syscall
    xor     %rdi, %rdi       # Code 0
    syscall

handle_timeout:
    # Afficher message timeout
    mov     $1, %rdi         # STDOUT
    lea     err_timeout(%rip), %rsi
    mov     $err_timeout_len, %rdx
    mov     $1, %rax         # write syscall
    syscall

    # Fermer le socket
    mov     %rbx, %rdi
    mov     $3, %rax         # close syscall
    syscall

    # Exit avec code 1
    mov     $60, %rax        # exit syscall
    mov     $1, %rdi         # Code 1
    syscall

error_exit:
    mov     $60, %rax        # exit syscall
    mov     $1, %rdi         # Code 1
    syscall