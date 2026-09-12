	.intel_syntax noprefix
	.text
	.globl	expand_q
	.type	expand_q, @function
expand_q:                       ;! long(ptr, long)
	kmovw	k1, esi
	vpxorq	zmm0, zmm0, zmm0
	vpexpandq	zmm0{k1}{z}, [rdi]
	vmovq	rax, xmm0
	ret
	.size	expand_q, .-expand_q

	.globl	compress_q
	.type	compress_q, @function
compress_q:                     ;! long(ptr, long)
	kmovw	k1, esi
	mov	rax, 11
	vpbroadcastq	zmm1, rax
	mov	rax, 55
	vpbroadcastq	zmm2, rax
	mov	rdx, 0x10
	kmovw	k2, edx
	vmovdqu64	zmm1{k2}, zmm2
	vpcompressq	[rdi]{k1}, zmm1
	mov	rax, 9
	ret
	.size	compress_q, .-compress_q

	.globl	expand_b
	.type	expand_b, @function
expand_b:                       ;! long(ptr, long)
	kmovq	k1, rsi
	vpxorq	zmm0, zmm0, zmm0
	vpexpandb	zmm0{k1}{z}, [rdi]
	vpextrb	eax, xmm0, 0
	ret
	.size	expand_b, .-expand_b

	.globl	compress_b
	.type	compress_b, @function
compress_b:                     ;! long(ptr, long)
	kmovq	k1, rsi
	mov	rax, 7
	vpbroadcastb	zmm1, eax
	mov	rax, 9
	vpbroadcastb	zmm2, eax
	mov	rdx, 2
	kmovq	k2, rdx
	vmovdqu8	zmm1{k2}, zmm2
	vpcompressb	[rdi]{k1}, zmm1
	mov	rax, 13
	ret
	.size	compress_b, .-compress_b

	.globl	expand_full
	.type	expand_full, @function
expand_full:                    ;! long(ptr, long)
	kmovw	k1, esi
	vpxorq	zmm0, zmm0, zmm0
	vpexpandq	zmm0{k1}{z}, [rdi]
	vextracti64x4	ymm1, zmm0, 1
	vpaddq	ymm0, ymm0, ymm1
	vextracti64x2	xmm1, ymm0, 1
	vpaddq	xmm0, xmm0, xmm1
	vpextrq	rdx, xmm0, 1
	vmovq	rax, xmm0
	add	rax, rdx
	ret
	.size	expand_full, .-expand_full
	.section	.note.GNU-stack,"",@progbits
