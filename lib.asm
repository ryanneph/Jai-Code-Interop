section .text
    ; Adding the "global" statement exports this symbol so the function can be
    ; located and linked with.
    global asm_add

; edi - a (s32)
; esi - b (s32)
; return a + b;
asm_add:
    mov  eax,edi
    add  eax,esi
    ret
