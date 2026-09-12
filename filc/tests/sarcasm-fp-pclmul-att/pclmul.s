	.text
	.globl	pclmul_lo
	.type	pclmul_lo, @function
pclmul_lo:                      ;! long(long, long)
	movq	%rdi, %xmm1
	movq	%rsi, %xmm2
	pclmulqdq	$0, %xmm2, %xmm1
	movq	%xmm1, %rax
	ret
	.size	pclmul_lo, .-pclmul_lo
	.globl	pclmul_hi
	.type	pclmul_hi, @function
pclmul_hi:                      ;! long(long, long)
	movq	%rdi, %xmm1
	movq	%rsi, %xmm2
	pclmulqdq	$0, %xmm2, %xmm1
	pextrq	$1, %xmm1, %rax
	ret
	.size	pclmul_hi, .-pclmul_hi
	.globl	pclmul_hh
	.type	pclmul_hh, @function
pclmul_hh:                      ;! long(long, long)
	movq	%rdi, %xmm1
	pinsrq	$1, %rdi, %xmm1
	movq	%rsi, %xmm2
	pinsrq	$1, %rsi, %xmm2
	pclmulqdq	$17, %xmm2, %xmm1
	movq	%xmm1, %rax
	ret
	.size	pclmul_hh, .-pclmul_hh
	.globl	sha_smoke
	.type	sha_smoke, @function
sha_smoke:                      ;! void(ptr)
	movdqu	(%rdi), %xmm1
	movdqu	16(%rdi), %xmm2
	movdqa	%xmm1, %xmm3
	pxor	%xmm0, %xmm0
	sha256rnds2	%xmm2, %xmm1
	movdqu	%xmm1, 32(%rdi)
	sha1rnds4	$0, %xmm2, %xmm3
	movdqu	%xmm3, 48(%rdi)
	ret
	.size	sha_smoke, .-sha_smoke
	.section	.note.GNU-stack,"",@progbits
