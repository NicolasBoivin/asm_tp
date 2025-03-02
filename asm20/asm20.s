global _start

section .data
    msg_prompt      db "Type a command: ",0
    prompt_size     equ $-msg_prompt
    msg_pong        db "PONG",10
    pong_size       equ $-msg_pong
    msg_goodbye     db "Goodbye!",10
    goodbye_size    equ $-msg_goodbye
    server_msg      db "⏳ Listening on port 4242",10
    server_msg_size equ $-server_msg
    lf              db 10
    cmd_ping        db "PING"
    ping_size       equ $-cmd_ping
    cmd_reverse     db "REVERSE"
    reverse_size    equ $-cmd_reverse
    cmd_echo        db "ECHO"
    echo_size       equ $-cmd_echo
    cmd_exit        db "EXIT"
    exit_size       equ $-cmd_exit

section .bss
    buffer      resb 256
    sock_addr   resb 16

section .text
_start:
    mov     rax, 41          
    mov     rdi, 2           
    mov     rsi, 1           
    xor     rdx, rdx         
    syscall
    mov     r12, rax         

    mov     word [sock_addr], 2
    mov     word [sock_addr+2], 0x9210
    xor     rax, rax
    mov     dword [sock_addr+4], eax
    mov     qword [sock_addr+8], rax

    mov     rax, 49          
    mov     rdi, r12         
    lea     rsi, [sock_addr]
    mov     rdx, 16
    syscall
    
    mov     rax, 50          
    mov     rdi, r12         
    mov     rsi, 10
    syscall

    mov     rax, 1           
    mov     rdi, 1
    lea     rsi, [server_msg]
    mov     rdx, server_msg_size
    syscall

    jmp server_loop

server_loop:
    mov     rax, 43          
    mov     rdi, r12
    xor     rsi, rsi
    xor     rdx, rdx
    syscall
    mov     r13, rax         
    
    mov     rax, 57          
    syscall
    test    rax, rax
    jz      handle_client    
    
    mov     rax, 3           
    mov     rdi, r13
    syscall
    jmp     server_loop

handle_client:
    mov     rax, 3           
    mov     rdi, r12
    syscall

command_loop:
    mov     rax, 1
    mov     rdi, r13
    lea     rsi, [msg_prompt]
    mov     rdx, prompt_size
    syscall
    
    mov     rax, 0
    mov     rdi, r13
    lea     rsi, [buffer]
    mov     rdx, 255
    syscall
    test    rax, rax
    jle     end_connection
    mov     rcx, rax
    mov     byte [buffer+rcx], 0

    mov     rdi, buffer
    lea     rsi, [cmd_ping]
    mov     rdx, ping_size
    call    str_compare
    cmp     rax, 0
    je      do_pong

    mov     rdi, buffer
    lea     rsi, [cmd_reverse]
    mov     rdx, reverse_size
    call    str_compare
    cmp     rax, 0
    je      handle_reverse

    mov     rdi, buffer
    lea     rsi, [cmd_echo]
    mov     rdx, echo_size
    call    str_compare
    cmp     rax, 0
    je      handle_echo

    mov     rdi, buffer
    lea     rsi, [cmd_exit]
    mov     rdx, exit_size
    call    str_compare
    cmp     rax, 0
    je      do_exit

    jmp     command_loop

str_compare:
    push    rcx
    mov     rcx, rdx
.loop:
    test    rcx, rcx
    jz      .equal
    mov     al, [rdi]
    cmp     al, [rsi]
    jne     .not_equal
    inc     rdi
    inc     rsi
    dec     rcx
    jmp     .loop
.equal:
    xor     rax, rax
    pop     rcx
    ret
.not_equal:
    mov     rax, 1
    pop     rcx
    ret

do_pong:
    mov     rax, 1
    mov     rdi, r13
    lea     rsi, [msg_pong]
    mov     rdx, pong_size
    syscall
    jmp     command_loop

handle_reverse:
    lea     rsi, [buffer+reverse_size]
.skip_spaces:
    cmp     byte [rsi], ' '
    je      .next_char
    jmp     .done_skipping
.next_char:
    inc     rsi
    jmp     .skip_spaces
.done_skipping:
    mov     r8, rsi
.find_end:
    mov     al, [rsi]
    cmp     al, 10
    je      .end_found
    cmp     al, 0
    je      .end_found
    inc     rsi
    jmp     .find_end
.end_found:
    mov     r9, rsi
    cmp     r9, r8
    je      empty_reverse
    dec     rsi
.reverse_loop:
    cmp     r8, rsi
    jge     finished_reverse
    mov     al, [r8]
    mov     bl, [rsi]
    mov     [r8], bl
    mov     [rsi], al
    inc     r8
    dec     rsi
    jmp     .reverse_loop

finished_reverse:
    lea     r10, [buffer+reverse_size]
.find_start:
    cmp     byte [r10], ' '
    je      .skip_one
    jmp     .found_start
.skip_one:
    inc     r10
    jmp     .find_start
.found_start:
    mov     rcx, r9
    sub     rcx, r10
    mov     rax, 1
    mov     rdi, r13
    mov     rsi, r10
    mov     rdx, rcx
    syscall
    mov     rax, 1
    mov     rdi, r13
    lea     rsi, [lf]
    mov     rdx, 1
    syscall
    jmp     command_loop

empty_reverse:
    mov     rax, 1
    mov     rdi, r13
    lea     rsi, [lf]
    mov     rdx, 1
    syscall
    jmp     command_loop

handle_echo:
    lea     rsi, [buffer+echo_size]
.skip_echo_spaces:
    cmp     byte [rsi], ' '
    je      .skip_next
    jmp     .done_echo_skip
.skip_next:
    inc     rsi
    jmp     .skip_echo_spaces
.done_echo_skip:
    mov     r8, rsi
.find_echo_end:
    mov     al, [rsi]
    cmp     al, 10
    je      .echo_end_found
    cmp     al, 0
    je      .echo_end_found
    inc     rsi
    jmp     .find_echo_end
.echo_end_found:
    mov     r9, rsi
    mov     rcx, r9
    sub     rcx, r8
    mov     rax, 1
    mov     rdi, r13
    mov     rsi, r8
    mov     rdx, rcx
    syscall
    mov     rax, 1
    mov     rdi, r13
    lea     rsi, [lf]
    mov     rdx, 1
    syscall
    jmp     command_loop

do_exit:
    mov     rax, 1
    mov     rdi, r13
    lea     rsi, [msg_goodbye]
    mov     rdx, goodbye_size
    syscall
    jmp     end_connection

end_connection:
    mov     rax, 3
    mov     rdi, r13
    syscall
    mov     rax, 60
    xor     rdi, rdi
    syscall