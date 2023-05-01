; ===============================
; Calculator ASM app entrypoint
; ===============================

[bits 64]


%include "utils/ioutils.asm"
%include "models/messages/messages.asm"
extern ExitProcess


[section .text]
global start

start:    
    mov     rdx, msgWelcome
    mov     r8, 0
    call    printString
    ; mov     rax, 8
    ; mov     rbx, 8
    ; mul     rax, rbx
    ; add     rax, 
    call    ExitProcess


[section .drectve info]
        db      '/entry:start /subsystem:console /defaultlib:kernel32.lib'
