	.text
	.globl	avx2_arith
	.type	avx2_arith, @function
avx2_arith:                     ;! long(ptr, ptr)
	vbroadcastss	(%rdi), %ymm0
	vaddps	%ymm0, %ymm0, %ymm1
	vaddps	%ymm1, %ymm0, %ymm2
	subq	$48, %rsp
	vmovdqu	%ymm2, (%rsp)
	vmovdqu	(%rsp), %ymm3
	addq	$48, %rsp
	vaddps	%ymm3, %ymm3, %ymm4
	vmovdqu	%ymm4, (%rsi)
	vextracti128	$1, %ymm4, %xmm5
	addss	%xmm4, %xmm5
	cvttss2siq	%xmm5, %rax
	ret
	.size	avx2_arith, .-avx2_arith
	.section	.note.GNU-stack,"",@progbits
