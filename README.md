Small assembly app

Assembly manual:

; x86_64 QWORD (64bit) registers ==
; =================================
; base registers        => rax rbx rcx rdx rbp rsp rsi rdi
; extended registers    => r8 r9 r10 r11 r12 r13 r14 r15

; x86_64 DWORD (32bit) registers ==
; =================================
; base registers        => eax ebx ecx edx ebp esp esi edi
; extended registers    => r8d r9d r10d r11d r12d r13d r14d r15d

; x86_64 WORD (16bit) registers ==
; =================================
; base registers        => ax bx cx dx bp sp si di
; extended registers    => r8w r9w r10w r11w r12w r13w r14w r15w

; x86_64 low-WORD (8bit) registers ==
; =================================
; base registers        => al bl cl dl
; extended registers    => r8b r9b r10b r11b r12b r13b r14b r15b

; x86_64 high-WORD (8bit) registers ==
; =================================
; base registers        => ah bh ch dh


; Build:
;
; nasm -f win64 hello.asm
; call "C:\\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" amd64
; link /entry:start /subsystem:console app.obj kernel32.lib 
;
; Requires nasm, Visual Studio build tools, e.g.
; nasm, visualstudio2017buildtools, visualstudio2017-workload-vctools Chocolatey packages
;
; shortcut for compile/link => createapp yourapp.asm
