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
    extern jai_add

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
    ; edi/dil - utf-8 codepoint (u8)
    sub rsp,1
    mov byte [rsp],dil
    mov rsi,rsp
    mov rdx,1
    call sys_write
    add rsp,1
    ret

; TODO: print any u8 - up to 3 digits
print_single_digit:
    ;; print a number in [0, 9] as char. will choke for numbers out-of-range.
    ; edi - num (s32)
    add edi,48 ; convert integer result to char
    call print_char
    ret

print_expression:
    ;; computes "c" and prints a string of the form "a + b = c"
    ; edi - param "a" (s32)
    ; esi - param "b" (s32)
    ; edx - param "c" (s32)

    ; non-volatile registers need to be restored before returning
    sub rsp,8
    mov dword [rsp],esi
    mov dword [rsp+4],edx

    ; print "a"
    ; "a" already in edi
    call print_single_digit

    ; print " + "
    mov edi,32
    call print_char
    mov edi,43
    call print_char
    mov edi,32
    call print_char

    ; print "b"
    mov dword edi,[rsp]
    call print_single_digit

    ; print " = "
    mov edi,32
    call print_char
    mov edi,61
    call print_char
    mov edi,32
    call print_char

    ; print resulting digit
    mov edi,[rsp+4]
    call print_single_digit
    call print_line_feed

    ; cleanup stack
    add rsp,8
    ret

asm_add_and_print:
    ;; call asm_add from our libasm
    ; print  "asm: "
    mov rsi,str_prefix
    mov rdx,len_prefix
    call sys_write

    ; print "asm_did "
    mov rsi,str_asm_did
    mov rdx,len_asm_did
    call sys_write

    mov edi,3
    mov esi,5
    call asm_add

    mov edx,eax
    call print_expression

    ret

cpp_add_and_print:
    ;; call cpp_add from our libc
    ; print "asm: "
    mov rsi,str_prefix
    mov rdx,len_prefix
    call sys_write

    ; print "cpp_did "
    mov rsi,str_cpp_did
    mov rdx,len_cpp_did
    call sys_write

    ; do a + b
    mov edi,6
    mov esi,2
    call cpp_add

    mov edx,eax
    call print_expression
    ret

jai_add_and_print:
    ;; call jai_add from our libjai
    ; print "asm: "
    mov rsi,str_prefix
    mov rdx,len_prefix
    call sys_write

    ; print "jai_did "
    mov rsi,str_jai_did
    mov rdx,len_jai_did
    call sys_write

    ; do a + b
    mov edi,6
    mov esi,2
    ; call jai_add ; TODO

    mov edx,eax
    call print_expression
    ret

_start:
    call asm_add_and_print
    call cpp_add_and_print
    ; call jai_add_and_print ; TODO

    ; do exit(error_code)
    mov rax,60 ; exit()
    mov edi,0 ; error_code (s32)
    syscall
