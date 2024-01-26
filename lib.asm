section .text

; Adding the "global" statement exports this symbol so the function can be
; located and linked with.
global asm_add
global asm_copy_bytes

; edi - a (s32)
; esi - b (s32)
; return a + b;
asm_add:
    mov  eax,edi
    add  eax,esi
    ret

; rdi - to    (*s64)
; rsi - from  (*s64)
; rdx - count (s64)
asm_copy_bytes:
    xor rax, rax
.loop:
    mov rcx, [rsi + rax * 8]
    mov [rdi + rax * 8], rcx
    inc rax
    cmp rax, rdx
    jb .loop
    ret
