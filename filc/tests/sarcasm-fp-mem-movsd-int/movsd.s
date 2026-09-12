	.intel_syntax noprefix
	.text
	.globl	store8
	.type	store8, @function
store8:                         ;! void(ptr, long)
	movq	xmm0, rsi
	movsd	QWORD PTR [rdi], xmm0
	ret
	.size	store8, .-store8
	.globl	load8
	.type	load8, @function
load8:                          ;! long(ptr)
	movsd	xmm0, QWORD PTR [rdi]
	movq	rax, xmm0
	ret
	.size	load8, .-load8
	.globl	store4
	.type	store4, @function
store4:                         ;! void(ptr, long)
	movd	xmm0, esi
	movss	DWORD PTR [rdi], xmm0
	ret
	.size	store4, .-store4
	.globl	load4
	.type	load4, @function
load4:                          ;! long(ptr)
	movss	xmm0, DWORD PTR [rdi]
	movd	eax, xmm0
	ret
	.size	load4, .-load4
	.section	.note.GNU-stack,"",@progbits
