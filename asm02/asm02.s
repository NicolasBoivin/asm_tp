section .bss
    input resb 3  

section .data
    message db "1337"

section .text
    global _start

_start:
    mov rax, 0      
    mov rdi, 0      
    mov rsi, input  
    mov rdx, 3      
    syscall         

    mov al, [input]  
    cmp al, '4'      
    jne exit_fail    

    mov al, [input+1]
    cmp al, '2'      
    jne exit_fail    

    mov rax, 1      
    mov rdi, 1      
    mov rsi, message 
    mov rdx, 4      
    syscall         

    mov rax, 60     
    xor rdi, rdi    
    syscall         

exit_fail:
    mov rax, 60     
    mov rdi, 1      
    syscall         
