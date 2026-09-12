	.text
	.globl	expand_q
	.type	expand_q, @function
expand_q:                       ;! long(ptr, long)
	# vpexpandq {z}-load at (%rdi) with {%k1}; return lane 0.
	kmovw	%esi, %k1
	vpxorq	%zmm0, %zmm0, %zmm0
	vpexpandq	(%rdi), %zmm0{%k1}{z}
	vmovq	%xmm0, %rax
	ret
	.size	expand_q, .-expand_q

	.globl	compress_q
	.type	compress_q, @function
compress_q:                     ;! long(ptr, long)
	# zmm0 = lanes {11,11,11,11,55,11,11,11}; vpcompressq store at (%rdi){%k1}
	# (mask 0x11 stores lane 0 then lane 4 to consecutive qwords).
	kmovw	%esi, %k1
	movq	$11, %rax
	vpbroadcastq	%rax, %zmm1
	movq	$55, %rax
	vpbroadcastq	%rax, %zmm2
	movq	$0x10, %rdx
	kmovw	%edx, %k2
	vmovdqu64	%zmm2, %zmm1{%k2}
	vpcompressq	%zmm1, (%rdi){%k1}
	movq	$9, %rax
	ret
	.size	compress_q, .-compress_q

	.globl	expand_b
	.type	expand_b, @function
expand_b:                       ;! long(ptr, long)
	# vpexpandb {z}-load at (%rdi) with {%k1}; return lane 0 (zero-extended).
	kmovq	%rsi, %k1
	vpxorq	%zmm0, %zmm0, %zmm0
	vpexpandb	(%rdi), %zmm0{%k1}{z}
	vpextrb	$0, %xmm0, %eax
	ret
	.size	expand_b, .-expand_b

	.globl	compress_b
	.type	compress_b, @function
compress_b:                     ;! long(ptr, long)
	# zmm0 = lanes {7,9,...}; vpcompressb store at (%rdi){%k1}
	# (mask 0x3 stores lane 0 then lane 1 to consecutive bytes).
	kmovq	%rsi, %k1
	movq	$7, %rax
	vpbroadcastb	%eax, %zmm1
	movq	$9, %rax
	vpbroadcastb	%eax, %zmm2
	movq	$2, %rdx
	kmovq	%rdx, %k2
	vmovdqu8	%zmm2, %zmm1{%k2}
	vpcompressb	%zmm1, (%rdi){%k1}
	movq	$13, %rax
	ret
	.size	compress_b, .-compress_b

	.globl	expand_full
	.type	expand_full, @function
expand_full:                    ;! long(ptr, long)
	# vpexpandq {z}-load of all 8 lanes at (%rdi); return the lane sum.
	kmovw	%esi, %k1
	vpxorq	%zmm0, %zmm0, %zmm0
	vpexpandq	(%rdi), %zmm0{%k1}{z}
	vextracti64x4	$1, %zmm0, %ymm1
	vpaddq	%ymm1, %ymm0, %ymm0
	vextracti64x2	$1, %ymm0, %xmm1
	vpaddq	%xmm1, %xmm0, %xmm0
	vpextrq	$1, %xmm0, %rdx
	vmovq	%xmm0, %rax
	addq	%rdx, %rax
	ret
	.size	expand_full, .-expand_full
	.section	.note.GNU-stack,"",@progbits
