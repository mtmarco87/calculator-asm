; ================================
; IO Utilities
; ================================

[bits 64]


extern GetStdHandle
extern ReadFile
extern WriteFile


[section .text]


; ReadString - Reads a string from StdInput
; @param rdx    -> message
; @param r8     -> message length (optional, if 0 length will be autodetected from end of line [\n])
readString:
	test	r8, r8							; Check param2 => if no message length has been passed => dynamic print
	jz		readDynamic
	
	call	readConcrete
	jmp		readEnd						; Finalize print and return
readDynamic:
	push	r12								; Store preserved register
	mov		r12, rdx						; Backup message to scratch register
	dec		r12
readLoopChars:
	inc		r12
	mov		rdx, r12						; Set param1 => message start address
	mov		r8, 1							; Set param2 => message length to 1
	call	readConcrete
	cmp		byte [r12], byte 0x0a			; Check if EOL has been reached
	jne		readLoopChars
	pop		r12								; Restore preserved register
readEnd:
    ret


; Concrete Read function wrapping around Kernel32 ReadFile
readConcrete:
    call    prepareStdInHandle				; Get StdHandle
    mov     qword [rsp-8], 0				; Clear previous func ret address from stack frame
    sub     rsp, 32+8						; Prepare Stack Pointer (32 empty bytes needed by Win64 func to store params + 8 bytes to align stack)
    mov     rcx, [rel stdin]				; Set param0 => StdIn pointer
    mov		rdx, read_buffer				; Set param1 => read buffer
    mov     r9, bytes_read  				; Set param3 => read bytes
	call    ReadFile						; Read from StdIn using ReadFile (it needs rcx, rdx, r8, r9 params filled)
    add     rsp, 32+8						; Restore Stack Pointer

	ret


; PrintString - Prints message to StdOutput
; @param rdx    -> message
; @param r8     -> message length (optional, if 0, length will be autodetected from null character [\0])
printString:
	test	r8, r8							; Check param2 => if no message length has been passed => dynamic print
	jz		printDynamic
	
	call	printConcrete
	jmp		printEnd						; Finalize print and return
printDynamic:
	push	r12								; Store preserved register
	mov		r12, rdx						; Backup message to scratch register
printLoopChars:
	mov		rdx, r12						; Set param1 => message start address
	mov		r8, 1							; Set param2 => message length to 1
	call	printConcrete
	inc		r12
	cmp		byte [r12], byte 0x00			; Check if \0 has been reached
	jne		printLoopChars
	pop		r12								; Restore preserved register
printEnd:
    ret


; Concrete Print function wrapping around Kernel32 WriteFile
printConcrete:
    call    prepareStdOutHandle				; Get StdHandle
    mov     qword [rsp-8], 0				; Clear previous func ret address from stack frame
    sub     rsp, 32+8						; Prepare Stack Pointer (32 empty bytes needed by Win64 func to store params + 8 bytes to align stack)
    mov     rcx, [rel stdout]				; Set param0 => StdOut pointer
    mov     r9, bytes_written				; Set param3 => written bytes
	call    WriteFile						; Print to StdOut using WriteFile (it needs rcx, rdx, r8, r9 params filled)
    add     rsp, 32+8						; Restore Stack Pointer

	ret


; PrepareStdInHandle - Obtains StdIn pointer
prepareStdInHandle:
    mov     rcx, stdin_query				; Get StdInHandle
    call    GetStdHandle
    mov     qword [rsp-8], 0				; Clear previous func ret address from stack frame
    mov     [rel stdin], rax

    ret


; PrepareStdOutHandle - Obtains StdOut pointer
prepareStdOutHandle:
    mov     rcx, stdout_query				; Get StdOutHandle
    call    GetStdHandle
    mov     qword [rsp-8], 0				; Clear previous func ret address from stack frame
    mov     [rel stdout], rax

    ret


[section .rodata]
stdin_query equ -10							; StdIn query
stdout_query equ -11						; StdOut query


[section .data]
stdin dw 0									; StdIn pointer         // HANDLE
stdout dw 0									; StdOut pointer        // HANDLE
read_buffer dw 0 							; Read buffer           // LPVOID
bytes_read dw 0 							; Total read bytes      // LPDWORD
bytes_written dw 0							; Total written bytes   // LPDWORD
