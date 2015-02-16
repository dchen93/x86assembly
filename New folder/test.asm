TITLE recursion (recurse.asm)
INCLUDE Irvine32.inc

.code
main PROC
mov eax, 4
push eax
call compute
call DumpRegs
exit
main ENDP

compute PROC
push ebp
mov ebp, esp
push ebx
mov eax, [ebp+8]
cmp eax, 1
je done
dec eax
push eax
call compute
call dumpregs
mov ebx, [ebp+8]
add eax, ebx
shl ebx, 2
add eax, ebx
jmp quit
done: mov eax, 1
quit: pop ebx
pop ebp
ret 4
compute ENDP

END main