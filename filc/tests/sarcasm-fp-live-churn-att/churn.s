	.text
	.globl	fp_churn
	.type	fp_churn, @function
fp_churn:                       ;! long(long, long, ptr)
	# Multi-width live state across BOTH an injected filc_allocate call (the
	# `;! alloca`) and every loop pollcheck, under FUGC churn:
	#   xmm0 @8, xmm1 @8, xmm6 @8  (scalar double accumulators)
	#   xmm2 @16                   (movdqu pair of doubles)
	#   ymm4 @32                   (vbroadcastss float x8)
	# The width-aware save/restore must emit, at each site, movsd for
	# xmm0/xmm1/xmm6, movdqu for xmm2, vmovdqu for ymm4 — exactly those five
	# registers, each at its live width (slots stride vecBytes=32).
	# (-S verified; ymm5 is written in the loop but dead across it.)
	cvtsi2sdq	%rsi, %xmm1
	pxor	%xmm0, %xmm0
	pxor	%xmm6, %xmm6
	movdqu	(%rdx), %xmm2
	vbroadcastss	16(%rdx), %ymm4
	leaq	64(%rsp), %rax      ;! alloca result size=64
	movq	%rax, %r10
	testq	%rdi, %rdi
	je	.Ldone
.Lloop:
	addsd	%xmm1, %xmm0
	addsd	%xmm1, %xmm6
	addsd	%xmm1, %xmm6
	vaddps	%ymm4, %ymm4, %ymm5
	subq	$1, %rdi
	jne	.Lloop
.Ldone:
	movdqu	%xmm2, (%r10)
	movdqu	(%r10), %xmm7
	movdqu	%xmm7, 32(%rdx)
	vmovdqu	%ymm4, 48(%rdx)
	cvttsd2siq	%xmm0, %rax
	cvttsd2siq	%xmm6, %rcx
	addq	%rcx, %rax
	ret
	.size	fp_churn, .-fp_churn
	.section	.note.GNU-stack,"",@progbits
