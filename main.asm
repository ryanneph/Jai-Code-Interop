section .data
    str_hello: db "hello from asm-land",10
    len_hello: equ $-str_hello

section .text
    global _start
    extern asm_add

sys_write:
    ;; caller provides:
    ; rsi - pointer to string (u64*)
    ; rdx - length of string (u64)
    mov rax,1 ; write()
    mov rdi,1 ; stdout
    syscall
    ret

_start:
    ; issue a write() syscall with a static string
    mov rsi,str_hello ; str_pointer
    mov rdx,len_hello ; str_len
    call sys_write

    ; call function from another translation unit
    ; add two numbers
    mov edi,4 ; num1
    mov esi,3 ; num2
    call asm_add

    ; build a string containing the digit then print the answer
    add rax,48 ; convert integer result to char
    ; make space on the stack
    mov byte [rsp-2],al ; output digit - lower byte of rax
    mov byte [rsp-1],10 ; linefeed
    sub rsp,2
    mov rsi,rsp
    mov rdx,2 ; string length
    call sys_write
    add rsp,2 ; cleanup our use of the stack

    ; exit(s32 error_code)
    mov rax,60 ; exit()
    mov rdi,0 ; error_code - SUCCESS
    syscall
