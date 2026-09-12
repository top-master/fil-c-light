	.text
	.globl	aes_roundtrip
	.type	aes_roundtrip, @function
aes_roundtrip:                  ;! void(ptr, ptr)
	movdqu	(%rdi), %xmm1
	movdqa	%xmm1, %xmm4
	aeskeygenassist	$1, %xmm1, %xmm2
	pshufd	$255, %xmm2, %xmm2
	movdqa	%xmm1, %xmm3
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pxor	%xmm2, %xmm1
	movdqa	%xmm1, %xmm5
	aeskeygenassist	$2, %xmm1, %xmm2
	pshufd	$255, %xmm2, %xmm2
	movdqa	%xmm1, %xmm3
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pxor	%xmm2, %xmm1
	movdqa	%xmm1, %xmm6
	aeskeygenassist	$4, %xmm1, %xmm2
	pshufd	$255, %xmm2, %xmm2
	movdqa	%xmm1, %xmm3
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pxor	%xmm2, %xmm1
	movdqa	%xmm1, %xmm7
	aeskeygenassist	$8, %xmm1, %xmm2
	pshufd	$255, %xmm2, %xmm2
	movdqa	%xmm1, %xmm3
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pxor	%xmm2, %xmm1
	movdqa	%xmm1, %xmm8
	aeskeygenassist	$16, %xmm1, %xmm2
	pshufd	$255, %xmm2, %xmm2
	movdqa	%xmm1, %xmm3
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pxor	%xmm2, %xmm1
	movdqa	%xmm1, %xmm9
	aeskeygenassist	$32, %xmm1, %xmm2
	pshufd	$255, %xmm2, %xmm2
	movdqa	%xmm1, %xmm3
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pxor	%xmm2, %xmm1
	movdqa	%xmm1, %xmm10
	aeskeygenassist	$64, %xmm1, %xmm2
	pshufd	$255, %xmm2, %xmm2
	movdqa	%xmm1, %xmm3
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pxor	%xmm2, %xmm1
	movdqa	%xmm1, %xmm11
	aeskeygenassist	$128, %xmm1, %xmm2
	pshufd	$255, %xmm2, %xmm2
	movdqa	%xmm1, %xmm3
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pxor	%xmm2, %xmm1
	movdqa	%xmm1, %xmm12
	aeskeygenassist	$27, %xmm1, %xmm2
	pshufd	$255, %xmm2, %xmm2
	movdqa	%xmm1, %xmm3
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pxor	%xmm2, %xmm1
	movdqa	%xmm1, %xmm13
	aeskeygenassist	$54, %xmm1, %xmm2
	pshufd	$255, %xmm2, %xmm2
	movdqa	%xmm1, %xmm3
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pslldq	$4, %xmm3
	pxor	%xmm3, %xmm1
	pxor	%xmm2, %xmm1
	movdqa	%xmm1, %xmm14
	movdqu	16(%rdi), %xmm0
	pxor	%xmm4, %xmm0
	aesenc	%xmm5, %xmm0
	aesenc	%xmm6, %xmm0
	aesenc	%xmm7, %xmm0
	aesenc	%xmm8, %xmm0
	aesenc	%xmm9, %xmm0
	aesenc	%xmm10, %xmm0
	aesenc	%xmm11, %xmm0
	aesenc	%xmm12, %xmm0
	aesenc	%xmm13, %xmm0
	aesenclast	%xmm14, %xmm0
	movdqu	%xmm0, (%rsi)
	pxor	%xmm14, %xmm0
	aesimc	%xmm13, %xmm15
	aesdec	%xmm15, %xmm0
	aesimc	%xmm12, %xmm15
	aesdec	%xmm15, %xmm0
	aesimc	%xmm11, %xmm15
	aesdec	%xmm15, %xmm0
	aesimc	%xmm10, %xmm15
	aesdec	%xmm15, %xmm0
	aesimc	%xmm9, %xmm15
	aesdec	%xmm15, %xmm0
	aesimc	%xmm8, %xmm15
	aesdec	%xmm15, %xmm0
	aesimc	%xmm7, %xmm15
	aesdec	%xmm15, %xmm0
	aesimc	%xmm6, %xmm15
	aesdec	%xmm15, %xmm0
	aesimc	%xmm5, %xmm15
	aesdec	%xmm15, %xmm0
	aesdeclast	%xmm4, %xmm0
	movdqu	%xmm0, 16(%rsi)
	ret
	.size	aes_roundtrip, .-aes_roundtrip
	.section	.note.GNU-stack,"",@progbits
