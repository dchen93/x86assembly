TITLE Lab 2, Daniel Chen, 997415944, dnlchen@ucdavis.edu	(lab2.asm)

; Objective: Compute f(x) = 1 + 3x + 3x^2 + x^3 +x^5 for positive integer x.

INCLUDE Irvine32.inc

.data
	sinput	BYTE "Enter the value of x : ",0
	soutput	BYTE "The value of y is    : ",0
.code
main PROC
	call crlf 		; new line
	mov edx, OFFSET sinput	; move to sinput location
	call WriteString	; print sinput
	mov ebx, 1		; f(x) = 1
	call ReadHex		; read input x
	mov edx, eax		; store x in edx
	mov ecx, 2		; loop 2 times
L1:	add eax, edx		; multiplication partial sum
	loop L1			; eax = 3x
	add ebx, eax		; f(x) = 1 + 3x
	mov eax, edx		; eax = x
	call x2
	mov ecx, 3		; loop 3 times
L2:	add ebx, eax		; f(x) = currentsum + x^2
	loop L2			; f(x) = 1 + 3x + 3x^2
	mov eax, edx		; eax = x
	call x3
	add ebx, eax		; f(x) = 1 + 3x + 3x^2 + x^3
	mov eax, edx		; eax = x
	call x5
	add ebx, eax		; f(x) = 1 + 3x + 3x^2 + x^3 + x^5
	mov edx, OFFSET soutput	; move to soutput location
	call WriteString	; print soutput
	mov eax, ebx
	call WriteHex		; print eax
	call crlf		; new line
	exit
main ENDP
x2 PROC
	push ecx		; push ecx onto stack
	push edx		; push edx onto stack
	mov ecx, eax		; ecx = x		
	
	mov eax, 0		; where x^2 will be stored
L1:	add eax, edx		; partial sum of x*x
	loop L1			; eax = x^2
	pop edx			; stack to edx
	pop ecx			; stack to ecx
	ret
x2 ENDP
x3 PROC
	push ecx		; push ecx onto stack
	push edx		; push edx onto stack
	mov ecx, eax		; ecx = x
	call x2
	mov edx, eax		; edx = x^2
	mov eax, 0		; eax = 0
L1:	add eax, edx		; partial sum of x*x^2
	loop L1			; eax = x^3
	pop edx			; stack to edx
	pop ecx			; stack to ecx
	ret
x3 ENDP
x5 PROC
	mov edx, eax		; edx = x
	call x2
	mov ecx, eax		; ecx = x^2
	mov eax, edx		; eax = x
	call x3
	mov edx, eax		; edx = x^3
	mov eax, 0		; eax = 0
L1:	add eax, edx		; partial sum of x^2*x^3
	loop L1			; eax = x^5
	ret
x5 ENDP
END main
