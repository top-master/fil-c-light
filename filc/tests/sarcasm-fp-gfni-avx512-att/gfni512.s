	.text
	.globl	gf_mul_zmm
	.type	gf_mul_zmm, @function
gf_mul_zmm:                     ;! void(ptr)
	# struct { uint8_t a[64]; uint8_t b[64]; uint8_t out[64]; }
	# EVEX zmm form (64-byte memory operand, GFNI+AVX512F).
	vmovdqu64	(%rdi), %zmm0
	vgf2p8mulb	64(%rdi), %zmm0, %zmm1
	vmovdqu64	%zmm1, 128(%rdi)
	ret
	.size	gf_mul_zmm, .-gf_mul_zmm
	.globl	gf_aff_zmm
	.type	gf_aff_zmm, @function
gf_aff_zmm:                     ;! void(ptr)
	# struct { uint8_t in[64]; uint64_t mat[8]; uint8_t out[64]; }
	vmovdqu64	(%rdi), %zmm0
	vgf2p8affineqb	$0, 64(%rdi), %zmm0, %zmm1
	vmovdqu64	%zmm1, 128(%rdi)
	ret
	.size	gf_aff_zmm, .-gf_aff_zmm
	.section	.note.GNU-stack,"",@progbits
