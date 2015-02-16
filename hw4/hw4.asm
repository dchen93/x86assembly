TITLE Daniel Chen, 997415944, hw4             (hw4.asm)

; read <11 numbers in, show # of positives and negatives

INCLUDE Irvine32.inc

.data
	input_num		SDWORD 10 DUP(0)
	input_string	BYTE "Enter an integer (0 to quit): ",0
	pos_num		BYTE "Number of positive numbers: ",0
	neg_num		BYTE "Number of negative numbers: ",0
	
.code
main PROC

	mov esi, OFFSET input_num
	mov ecx, 10
L1:	mov edx, OFFSET input_string
	call WriteString
	call Readint
	mov [esi], eax
	add esi, 4
	sub eax, 0
	loopnz L1
	
	mov edi, OFFSET input_num
	mov ecx, 10
	mov ebx, 0
	mov edx, 0
L2:	mov eax, [edi]
	cmp eax, 0
	jg pos_in
	jl neg_in
	jmp next
pos_in:	inc ebx
	jmp next
neg_in:	inc edx
next:	add edi, 4
	loop L2
	
	mov eax, ebx
	mov ebx, edx
	mov edx, OFFSET pos_num
	call WriteString
	call WriteInt
	call crlf
	mov eax, ebx
	mov edx, OFFSET neg_num
	call WriteString
	call WriteInt
	call crlf
	
	exit
main ENDP
END main