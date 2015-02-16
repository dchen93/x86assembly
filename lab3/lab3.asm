TITLE Lab 3, Daniel Chen, 997415944, dnlchen@ucdavis.edu	(lab3.asm)

; 6 labs, 25%, drop lowest; 6 homework, 15%, drop lowest; exam1 10%, exam2 20%; examf 30%

INCLUDE Irvine32.inc

.data
	lab		BYTE 6 DUP(?)
	hw		BYTE 6 DUP(?)
	exam		BYTE 3 DUP(?)
	lab_in		BYTE "Enter the six lab grades: ",0
	lab_grade	BYTE "Lab0: ",0
	hw_in		BYTE "Enter the six Hw grades: ",0
	hw_grade	BYTE "Hw0: ",0
	exam_in		BYTE "Enter the three exam grades: ",0
	exam_grade	BYTE "Exam0: ",0
	total		BYTE "Total Grade = ",0
	letter		BYTE "Letter Grade = ",0
	
.code
main PROC
;READ LAB
	mov edx, OFFSET lab_in		; location of input direction
	call WriteString		; write input direction
	call crlf			; newline
	mov edi, OFFSET lab		; location of lab grade storage
	mov ecx, 6			; for all six labs
L1:	inc [lab_grade+3]		; increase lab number
	mov edx, OFFSET lab_grade	; location of lab input direction
	call WriteString		; write
	call Readint			; read into al
	mov [edi], al			; move number to lab grade storage
	inc edi				; move to next location for storage
	loop L1				; read in all six

;READ HW
	mov edx, OFFSET hw_in		; copy, paste, and adjust variables from LABS
	call WriteString
	call crlf
	mov edi, OFFSET hw
	mov ecx, 6
L2:	inc [hw_grade+2]
	mov edx, OFFSET hw_grade
	call WriteString
	call Readint
	mov [edi], al
	inc edi
	loop L2

;READ EXAM
	mov edx, OFFSET exam_in		; copy, paste, and adjust variables and numbers from LABS
	call WriteString
	call crlf
	mov edi, OFFSET exam
	mov ecx, 3
L3:	inc [exam_grade+4]
	mov edx, OFFSET exam_grade
	call WriteString
	call Readint
	mov [edi], al
	inc edi
	loop L3

;CALC PARTIAL TOTAL GRADE (LAB)
	mov esi, OFFSET lab		; location of lab grades
	movzx bx, BYTE PTR [esi]	; lab1 to bx
	mov dx, bx			; lab1 to dx (lowest)
	mov ax, bx			; lab1 to ax
	inc esi				; to lab2
	mov ecx, 5			; five iterations to compare and add
L4:	movzx bx, BYTE PTR [esi]	; labX to bx
	add ax, bx			; add labX to lab total
	cmp bx, dx			; compare bx-dx
	jg N1				; if greater, then N1
	mov dx, bx			; else, move bx to dx
N1:	inc esi				; to next labX
	loop L4
	sub ax, dx			; substract lowest from total
	mov dx, ax			; move total to dx
	add ax, ax			; ax = 2dx
	add ax, ax			; ax = 4dx
	add ax, dx			; ax = 5dx
	push ax				; lab total onto stack
	
;CALC PARTIAL TOTAL GRADE (LAB+HW)
	mov esi, OFFSET hw		; copy, paste, and adjust variables from CALC PARTIAL TOTAL GRADE (LAB)
	movzx bx, BYTE PTR [esi]
	mov dx, bx
	mov ax, bx
	inc esi
	mov ecx, 5
L5:	movzx bx, BYTE PTR [esi]
	add ax, bx
	cmp bx, dx
	jg N2
	mov dx, bx
N2:	inc esi
	loop L5
	sub ax, dx
	mov dx, ax			; dx = ax
	add ax, ax			; ax = 2dx
	add ax, dx			; ax = 3dx
	mov bx, ax			; move ax to bx
	pop ax				; ax = lab total
	add ax, bx			; ax = lab+hw total
	push ax				; partial total onto stack

;CALC TOTAL GRADE (LAB+HW+EX1+EX2+EXF)
	mov esi, OFFSET exam
	movzx bx, BYTE PTR [esi]	; ex1 to bx
	mov ax, bx			; ex1 to ax
	add ax, ax			; ax = 2ex1
	mov bx, ax			; bx = 2ex1
	add ax, ax			; ax = 4ex1
	add ax, ax			; ax = 8ex1
	add ax, bx			; ax = 10ex1
	mov bx, ax			; move ax to bx
	pop ax				; ax = partial total
	add ax, bx			; ax = new partial total
	push ax				; partial total onto stack
	
	inc esi
	movzx ax, BYTE PTR [esi]	; ex2 to ax
	add ax, ax			; ax = 2ex2
	add ax, ax			; ax = 4ex2
	mov bx, ax			; bx = 4ex2
	add ax, ax			; ax = 8ex2
	add ax, ax			; ax = 16ex2
	add ax, bx			; ax = 20ex2
	mov bx, ax			; bx = ax
	pop ax				; ax = partial total
	add ax, bx			; ax = new partial total
	push ax				; partial total onto stack
	
	inc esi
	movzx ax, BYTE PTR [esi]	; exf to ax
	add ax, ax			; ax = 2exf
	mov bx, ax			; bx = 2exf
	add ax, ax			; ax = 4exf
	add ax, ax			; ax = 8exf
	add ax, ax			; ax = 16exf
	add ax, ax			; ax = 32exf
	sub ax, bx			; ax = 30exf
	mov bx, ax			; bx = ax
	pop ax				; ax = partial total
	add ax, bx			; ax = total
	
	mov bl, 100
	div bl				; total / 100
	mov edx, OFFSET total		; total intro location
	call WriteString		; print total intro
	movzx eax, al			; zeroextend total to eax
	call WriteInt			; write total
	call crlf			; newline

;CALC LETTER GRADE
	mov edx, OFFSET letter		; letter intro location
	call WriteString		; print letter intro
	cmp eax, 85			; compare total to 85
	jg IF_A				; if greater than 85, go to IF_A
	cmp eax, 75			; same as above
	jg IF_B
	cmp eax, 65			; same as above
	jg IF_C
	cmp eax, 59			; same as above
	jg IF_D
	mov al, 'F'			; else move F to al
	jmp PRINT			; and go to print
IF_A:	mov al, 'A'			; move A to al
	jmp PRINT			; and go to print
IF_B:	mov al, 'B'			; same as above
	jmp PRINT
IF_C:	mov al, 'C'			; same as above
	jmp PRINT
IF_D:	mov al, 'D'			; same as above
PRINT:	call WriteChar			; write char stored in al
	call crlf			; newline
	exit
	
main ENDP
END main
