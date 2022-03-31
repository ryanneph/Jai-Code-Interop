section .data
    str_hello: db "hello from asm-land",10
    len_hello: equ $-str_hello
    str_prefix: db "asm: "
    len_prefix: equ $-str_prefix
    str_line_feed: db 10
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
    ;; slightly cheaper than print_char, becuase we store LF in .data
    mov rsi,str_line_feed
    mov rdx,1
    call sys_write
    ret

print_char:
    ;; print a single char by its utf-8 codepoint
    ; rsi - utf-8 codepoint (u8)
    sub rsp,1
    mov byte [rsp],sil
    mov rsi,rsp
    mov rdx,1
    call sys_write
    add rsp,1
    ret

; TODO: print any u8 - up to 3 digits
print_single_digit:
    ; print a number in [0, 9] as char. will choke for numbers out-of-range.
    ;; caller provides:
    ; esi - num (u8)
    add esi,48 ; convert integer result to char
    call print_char
    ret

cpp_add_and_print:
    ;; call cpp_add from our libc - no params
    ; print "asm: "
    mov rsi,str_prefix
    mov rdx,len_prefix
    call sys_write

    ; print "cpp_did "
    mov rsi,str_cpp_did
    mov rdx,len_cpp_did
    call sys_write

    ; print "4"
    mov esi,4
    call print_single_digit

    ; print " + "
    mov esi,32
    call print_char
    mov esi,43
    call print_char
    mov esi,32
    call print_char

    ; print "3"
    mov esi,3
    call print_single_digit

    ; print " = "
    mov esi,32
    call print_char
    mov esi,61
    call print_char
    mov esi,32
    call print_char

    ; do a + b
    mov esi,4 ; param "a" (s32)
    mov esi,3 ; param "b" (s32)
    call cpp_add

    ; print resulting digit
    mov esi,eax
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
    mov esi,eax
    call print_single_digit
    call print_line_feed

    call cpp_add_and_print

    ; do exit(error_code)
    mov rax,60 ; exit()
    mov edi,0 ; error_code (s32)
    syscall
