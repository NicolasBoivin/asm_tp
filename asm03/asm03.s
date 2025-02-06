section .data
    message db "1337", 0

section .text
    global _start

_start:
    mov rdi, [rsp+8]   
    test rdi, rdi      
    jz exit_fail       

    mov rsi, [rdi]     
    mov eax, dword [rsi] 
    cmp eax, '42'       
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
