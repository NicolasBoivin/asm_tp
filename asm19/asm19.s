global _start

section .data
    server_msg:         db "⏳ Listening on port 1337", 10
    server_msg_len:     equ $ - server_msg

    err_socket:         db "Socket error",10
    err_socket_len:     equ $ - err_socket

    err_bind:           db "Bind error",10
    err_bind_len:       equ $ - err_bind

    err_file:           db "Open file error",10
    err_file_len:       equ $ - err_file

    line_break:         db 10
    line_break_len:     equ $ - line_break

    server_addr:
        dw 2
        dw 0x3905
        dd 0
        times 8 db 0
    addr_size: equ $ - server_addr

    log_file:    db "messages",0

section .text
_start:
    mov     rax, 41
    mov     rdi, 2
    mov     rsi, 2
    xor     rdx, rdx
    syscall
    test    rax, rax
    js      handle_socket_error
    mov     r14, rax

    mov     rax, 49
    mov     rdi, r14
    lea     rsi, [rel server_addr]
    mov     rdx, addr_size
    syscall
    test    rax, rax
    js      handle_bind_error

    mov     rax, 257
    mov     rdi, -100
    lea     rsi, [rel log_file]
    mov     rdx, 1089
    mov     r10, 420
    syscall
    test    rax, rax
    js      handle_file_error
    mov     r15, rax

    mov     rax, 1
    mov     rdi, 1
    lea     rsi, [rel server_msg]
    mov     rdx, server_msg_len
    syscall

receive_loop:
    sub     rsp, 1024

    mov     rax, 45
    mov     rdi, r14
    mov     rsi, rsp
    mov     rdx, 1024
    xor     r10, r10
    xor     r8, r8
    xor     r9, r9
    syscall
    test    rax, rax
    js      handle_receive_error
    mov     rbx, rax

    mov     rax, 1
    mov     rdi, r15
    mov     rsi, rsp
    mov     rdx, rbx
    syscall

    cmp     rbx, 0
    je      append_newline
    
    mov     al, byte [rsp + rbx - 1]
    cmp     al, 10
    je      skip_newline
    
append_newline:
    mov     rax, 1
    mov     rdi, r15
    lea     rsi, [rel line_break]
    mov     rdx, line_break_len
    syscall
    
skip_newline:
    add     rsp, 1024
    jmp     receive_loop

handle_receive_error:
    add     rsp, 1024
    jmp     receive_loop

handle_socket_error:
    mov     rax, 1
    mov     rdi, 2
    lea     rsi, [rel err_socket]
    mov     rdx, err_socket_len
    syscall
    jmp     exit_program

handle_bind_error:
    mov     rax, 1
    mov     rdi, 2
    lea     rsi, [rel err_bind]
    mov     rdx, err_bind_len
    syscall
    jmp     exit_program

handle_file_error:
    mov     rax, 1
    mov     rdi, 2
    lea     rsi, [rel err_file]
    mov     rdx, err_file_len
    syscall
    jmp     exit_program

exit_program:
    mov     rax, 60
    mov     rdi, 1
    syscall 
