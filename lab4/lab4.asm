TITLE Lab 4, Daniel Chen, 997415944, dnlchen@ucdavis.edu	(lab4.asm)

; Fib1 calcs Fib(n) for positive n, single loop; Fib2 does the same with recursion; main reads n in hex, and prints the hex value of Fib(n) for both, and print execution time in ms of Fib2

INCLUDE Irvine32.inc

.data
	in_prompt	BYTE "Enter the value of n in Hex: ",0
	out1		BYTE "Hex value of F(n) using Fib1: ",0
	out2		BYTE "Hex value of F(n) using Fib2: ",0
	time2		BYTE "Execution time of Fib2 in ms: ",0
	
.code
main PROC
	mov edx, OFFSET in_prompt	; location of in_prompt
	call WriteString		; write in_prompt
	call ReadHex			; store number in eax
	push eax			; eax onto stack
	call Fib1			; single loop fib(n)
	mov edx, OFFSET out1		; location of out1
	call WriteString		; write out1
	call WriteHex			; write fib1
	call crlf			; newline
	pop eax				; reset eax
	push eax			; to pass to Fib2
	call GetMseconds		; get start time
	mov ebx, eax			; store start time in ebx
	call Fib2			; recursive fib(n)
	push eax			; store fib(n) in stack
	call GetMseconds		; get stop time
	sub eax, ebx			; calculate elapsed time
	mov ebx, eax			; save elapsed time in ebx
	pop eax				; restore fib(n) to eax
	mov edx, OFFSET out2		; location of out2
	call WriteString		; write out2
	call WriteHex			; write fib2
	call crlf			; newline
	mov edx, OFFSET time2		; location of time2
	call WriteString		; write time2
	mov eax, ebx			; move elapsed time to eax
	call WriteDec			; print execution time in decimal format with no leading zeroes
	call crlf			; newline
	exit	
main ENDP

Fib1 PROC
	mov ecx, eax			; number to ecx
	cmp ecx, 3			; check if n is <3
	jb first2			; jump to first2
	sub ecx, 2			; first two accounted for in...
	mov eax, 1			; eax fib(n-1) and...
	mov ebx, 1			; ebx fib(n-2)
L1:	mov edx, eax			; edx stores fib(n-1)
	add eax, ebx			; add fib(n-1) + fib(n-2), store fib(n) in eax
	mov ebx, edx			; ebx is fib(n-1)
	loop L1				; onto next n
	jmp finish			; skip over first2
first2:	mov eax, 1			; first two of fib are 1
finish:	ret
Fib1 ENDP

Fib2 PROC
	push ebp			; save old base pointer
	mov ebp, esp			; set new base pointer
	push ebx			; save ebx
	mov eax, [ebp+8]		; move hex number to eax
	cmp eax, 3			; if n is <3
	jb first2			; jump to first2
	dec eax				; eax = n-1
	push eax			; save n-1 for next call
	call Fib2			; call fib2 for n-1
	mov ebx, eax			; store fib(n-1) in ebx
	mov eax, [ebp+8]		; move n to eax
	sub eax, 2			; eax = n-2
	push eax			; save n-2 for next call
	call Fib2			; call fib2 for n-2
	add eax, ebx			; add fib(n-1) and fib(n-2)
	jmp finish			; skip first2 if not first 2
first2:	mov eax, 1			; first two of fib are 1
finish:	pop ebx				; restore ebx
	pop ebp				; restore base pointer value
	ret 4				; clean up stack
Fib2 ENDP

END main
