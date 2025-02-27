 .section .data
prefix:
    .ascii "message: \""
prefix_len = . - prefix

suffix:
    .ascii "\"\n"
suffix_len = . - suffix

timeout_msg:
    .ascii "Timeout: no response from server\n"
timeout_msg_len = . - timeout_msg

query:
    .ascii "ping"
query_len = . - query

dest:
    .word 2
    .word 0x3905
    .long 0x0100007f
    .quad 0

timeval:
    .quad 1
    .quad 0

    .section .bss
    .lcomm recvbuf,256

    .section .text
    .global _start
_start:
    movq    $41, %rax
    movq    $2, %rdi
    movq    $2, %rsi
    xor    %rdx, %rdx
    syscall
    cmpq    $0, %rax
    js    exit_fail
    movq    %rax, %r12

    movq    %r12, %rdi
    movq    $1, %rsi
    movq    $20, %rdx
    leaq    timeval(%rip), %r10
    movq    %r10, %r10
    movq    $16, %r8
    movq    $54, %rax
    syscall

    movq    %r12, %rdi
    leaq    query(%rip), %rsi
    movq    $query_len, %rdx
    xor    %r10, %r10
    leaq    dest(%rip), %r8
    movq    $16, %r9
    movq    $44, %rax
    syscall

    movq    %r12, %rdi
    leaq    recvbuf(%rip), %rsi
    movq    $256, %rdx
    xor    %r10, %r10
    xor    %r8, %r8
    xor    %r9, %r9
    movq    $45, %rax
    syscall
    cmpq    $0, %rax
    js    timeout_label
    movq    %rax, %r13

    movq    $1, %rdi
    leaq    prefix(%rip), %rsi
    movq    $prefix_len, %rdx
    movq    $1, %rax
    syscall

    movq    $1, %rdi
    leaq    recvbuf(%rip), %rsi
    movq    %r13, %rdx
    movq    $1, %rax
    syscall

    movq    $1, %rdi
    leaq    suffix(%rip), %rsi
    movq    $suffix_len, %rdx
    movq    $1, %rax
    syscall

    movq    %r12, %rdi
    movq    $3, %rax
    syscall

    movq    $60, %rax
    xor    %rdi, %rdi
    syscall

timeout_label:
    movq    $1, %rdi
    leaq    timeout_msg(%rip), %rsi
    movq    $timeout_msg_len, %rdx
    movq    $1, %rax
    syscall

    movq    %r12, %rdi
    movq    $3, %rax
    syscall

    movq    $60, %rax
    movq    $1, %rdi
    syscall

exit_fail:
    movq    $60, %rax
    movq    $1, %rdi
    syscall