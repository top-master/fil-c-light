	.intel_syntax noprefix
	.text
	.globl	fp_churn_int
	.type	fp_churn_int, @function
fp_churn_int:                   ;! long(long, long, ptr)
	# Intel-syntax twin of sarcasm-fp-live-churn-att: multi-width live state
	# (xmm0/xmm1/xmm6 @8, xmm2 @16, ymm4 @32) across an injected
	# filc_allocate call and every loop pollcheck. The width-aware
	# save/restore must emit movsd for xmm0/xmm1/xmm6, movdqu for xmm2,
	# vmovdqu for ymm4 — exactly those five registers, each at its live
	# width (-S verified).
	cvtsi2sd	xmm1, rsi
	pxor	xmm0, xmm0
	pxor	xmm6, xmm6
	movdqu	xmm2, XMMWORD PTR [rdx]
	vbroadcastss	ymm4, DWORD PTR [rdx+16]
	lea	rax, [rsp+64]       ;! alloca result size=64
	mov	r10, rax
	test	rdi, rdi
	je	.Ldone
.Lloop:
	addsd	xmm0, xmm1
	addsd	xmm6, xmm1
	addsd	xmm6, xmm1
	vaddps	ymm5, ymm4, ymm4
	sub	rdi, 1
	jne	.Lloop
.Ldone:
	movdqu	XMMWORD PTR [r10], xmm2
	movdqu	xmm7, XMMWORD PTR [r10]
	movdqu	XMMWORD PTR [rdx+32], xmm7
	vmovdqu	YMMWORD PTR [rdx+48], ymm4
	cvttsd2si	rax, xmm0
	cvttsd2si	rcx, xmm6
	add	rax, rcx
	ret
	.size	fp_churn_int, .-fp_churn_int
	.section	.note.GNU-stack,"",@progbits
