	.intel_syntax noprefix
	.text
	.globl	f_arith
	.type	f_arith, @function
f_arith:                        ;! long(long, long)
	cvtsi2sd	xmm0, rdi
	cvtsi2sd	xmm1, rsi
	movsd	xmm2, xmm0
	addsd	xmm2, xmm1
	movsd	xmm3, xmm0
	subsd	xmm3, xmm1
	movsd	xmm4, xmm0
	mulsd	xmm4, xmm1
	movsd	xmm5, xmm0
	divsd	xmm5, xmm1
	sqrtsd	xmm6, xmm4
	movsd	xmm7, xmm2
	minsd	xmm7, xmm4
	movsd	xmm8, xmm3
	maxsd	xmm8, xmm5
	xor	eax, eax
	comisd	xmm2, xmm4
	setb	al
	xor	r8d, r8d
	ucomisd	xmm0, xmm3
	seta	r8b
	cvttsd2si	rcx, xmm2
	cvttsd2si	rdx, xmm3
	add	rcx, rdx
	cvttsd2si	rdx, xmm4
	add	rcx, rdx
	cvttsd2si	rdx, xmm5
	add	rcx, rdx
	cvttsd2si	rdx, xmm6
	add	rcx, rdx
	cvttsd2si	rdx, xmm7
	add	rcx, rdx
	cvttsd2si	rdx, xmm8
	add	rcx, rdx
	add	rcx, rax
	add	rcx, r8
	add	rcx, rdi
	mov	rax, rcx
	ret
	.size	f_arith, .-f_arith
	.section	.note.GNU-stack,"",@progbits
