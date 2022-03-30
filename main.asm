section .data
    str_hello: db "hello from asm-land",10
    len_hello: equ $-str_hello
    str_prefix: db "asm: "
    len_prefix: equ $-str_prefix
    str_line_feed: db 10
    len_line_feed: equ 1
    str_asm_did: db "asm did "
    len_asm_did: equ $-str_asm_did
    str_cpp_did: db "cpp did "
    len_cpp_did: equ $-str_cpp_did
    str_jai_did: db "jai did "
    len_jai_did: equ $-str_jai_did

section .text
    global _start
    extern asm_add
    extern cpp_add

sys_write:
    ;; caller provides:
    ; rsi - pointer to string (u64*)
    ; rdx - length of string (u64)
    mov rax,1 ; write()
    mov rdi,1 ; stdout
    syscall
    ret

print_line_feed:
    mov rsi,str_line_feed
    mov rdx,len_line_feed
    call sys_write
    ret

print_single_digit:
    ; print a number in [0, 9] as char. will choke for numbers out-of-range.
    ;; caller provides:
    ; edi - num
    add edi,48 ; convert integer result to char

    ; make some space on the stack to store our char (can probably use the
    ;   red-zone for this instead to save some instructions)
    sub rsp,1
    mov byte [rsp],dil ; output digit - lower byte of edi
    mov rsi,rsp
    mov rdx,1 ; string length
    call sys_write
    add rsp,1 ; cleanup our use of the stack
    ret

cpp_add_and_print:
    ;; call cpp_add from our libc
    ; first print the result with some flavor text
    mov rsi,str_prefix
    mov rdx,len_prefix
    call sys_write ; write "asm: "

    mov rsi,str_cpp_did
    mov rdx,len_cpp_did
    call sys_write ; write "cpp_did "

    mov edi,4
    call print_single_digit

    ; hack to print a string as chars ' + '
    ; TODO build string on stack, instead?
    mov edi,-16
    call print_single_digit
    mov edi,-5
    call print_single_digit
    mov edi,-16
    call print_single_digit

    mov edi,3
    call print_single_digit

    ; hack to print a string as chars ' = '
    ; TODO build string on stack, instead?
    mov edi,-16
    call print_single_digit
    mov edi,13
    call print_single_digit
    mov edi,-16
    call print_single_digit

    ; a + b
    mov edi,4 ; param "a" (s32)
    mov esi,3 ; param "b" (s32)
    call cpp_add
    ; print resulting digit
    mov edi,eax
    call print_single_digit
    call print_line_feed
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
    mov edi,eax
    call print_single_digit
    call print_line_feed

    call cpp_add_and_print

    ; exit(s32 error_code)
    mov rax,60 ; exit()
    mov rdi,0 ; error_code - SUCCESS
    syscall
