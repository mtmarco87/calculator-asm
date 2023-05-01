; ===============================
; App Messages
; ===============================

[bits 64]

[section .rodata]
msgWelcome         db  "========================================", 0x0d, 0x0a,
                   db  0x0d, 0x0a,
                   db  "CalculatorASM app 1.0.0 // ", 0xa9, "2023 mtApps", 0x0d, 0x0a,
                   db  0x0d, 0x0a,
                   db  "========================================", 0x0d, 0x0a, 
                   db  0x0a, 0x0a, 0x0a ; == \r\n\0
msgWelcome_len     equ $-msgWelcome
