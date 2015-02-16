TITLE Lab 1, Daniel Chen, 997415944, dnlchen@ucdavis.edu	(lab1.asm)

; Objective: Compute f(n) = n! + n^2 + 1 for integer n where 0<n<11.

INCLUDE Irvine32.inc

.code
main PROC

	mov edx, 1 	; (n-1)!
	mov ebx, 1	; ebx is n, starts at 1
L1:
	mov eax, 0	; reset f
	mov ecx, ebx	; loop L2 n times
L2:
	add eax, edx	; add factorial partial sum to f
	loop L2		; add factorial total sum
	mov edx, eax	; store factorial total sum in edx
	mov ecx, ebx	; loops L3 n times
L3:
	add eax, ebx	; add n to multiplication partial sum
	loop L3		; add in multiplication total sum
	add eax, 1	; add one to sum to complete f
	call DumpRegs	; print f
	mov ecx, 11	; preparation for next instruction
	sub ecx, ebx	; if n is 10, ecx becomes 1
	inc ebx		; n++
	loop L1		; repeat for next n
	
	exit
main ENDP
END main
