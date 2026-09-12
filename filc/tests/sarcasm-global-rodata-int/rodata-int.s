	.intel_syntax noprefix
	.text
	.globl	roread
	.type	roread, @function
roread:                         ;! long()
	mov	eax, DWORD PTR [rip+tab]
	add	eax, DWORD PTR [rip+tab+4]
	add	eax, DWORD PTR [rip+tab+8]
	add	eax, DWORD PTR [rip+tab+12]
	ret
	.size	roread, .-roread
	.globl	roread2
	.type	roread2, @function
roread2:                        ;! long(long)
	mov	eax, DWORD PTR [rip+tab+8]
	add	eax, DWORD PTR [rip+tab]
	add	eax, DWORD PTR [rip+msg]
	movzx	ecx, BYTE PTR [rip+msg+5]
	add	eax, ecx
	ret
	.size	roread2, .-roread2
	.section	.rodata
	.p2align	4
tab:
	.long	10, 20, 30, 40
msg:
	.byte	5
	.zero	4
	.byte	7
	.section	.note.GNU-stack,"",@progbits
