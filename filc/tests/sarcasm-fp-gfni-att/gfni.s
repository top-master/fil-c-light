	.text
	.globl	gf_mul
	.type	gf_mul, @function
gf_mul:                         ;! void(ptr)
	# struct { uint8_t a[16]; uint8_t b[16]; uint8_t out[16]; }
	# out = gf(2^8) multiply of a and b (16-byte memory operand).
	vmovdqu	(%rdi), %xmm0
	gf2p8mulb	16(%rdi), %xmm0
	vmovdqu	%xmm0, 32(%rdi)
	ret
	.size	gf_mul, .-gf_mul
	.globl	gf_aff
	.type	gf_aff, @function
gf_aff:                         ;! void(ptr)
	# struct { uint8_t in[16]; uint64_t mat[2]; uint8_t out[16]; }
	# affine transform with the identity-matrix qword 0x0102040810204080
	# and imm 0 returns the input byte-exact.
	vmovdqu	(%rdi), %xmm0
	gf2p8affineqb	$0, 16(%rdi), %xmm0
	vmovdqu	%xmm0, 32(%rdi)
	ret
	.size	gf_aff, .-gf_aff
	.globl	gf_mul_ymm
	.type	gf_mul_ymm, @function
gf_mul_ymm:                     ;! void(ptr)
	# struct { uint8_t a[32]; uint8_t b[32]; uint8_t out[32]; }
	# VEX ymm form (32-byte memory operand).
	vmovdqu	(%rdi), %ymm0
	vgf2p8mulb	32(%rdi), %ymm0, %ymm1
	vmovdqu	%ymm1, 64(%rdi)
	ret
	.size	gf_mul_ymm, .-gf_mul_ymm
	.section	.note.GNU-stack,"",@progbits
