# An align=32 fixed alloca region: the allocation is over-sized and the region
# pointer aligned up to 32, so `vmovdqa` (32-byte aligned) stack traffic --
# the ChaCha20_8x / rsaz_avx2 idiom -- works, at exact bounds.
	.text
	.globl	align32
	.type	align32, @function
align32:                        ;! void(ptr)
	movq	%rsp, %rax
	subq	$64+32, %rsp
	andq	$-32, %rsp          ;! alloca result size=64
	vmovdqu	(%rdi), %ymm0       # load 2 x 32 bytes (unaligned source)
	vmovdqu	32(%rdi), %ymm1
	vmovdqa	%ymm0, 0(%rsp)      # 32-byte aligned stores into the region
	vmovdqa	%ymm1, 32(%rsp)
	vpxor	%ymm1, %ymm0, %ymm2
	vmovdqa	%ymm2, 0(%rsp)
	movq	%rax, 56(%rsp)      # hmm: 56 is in [0,64) -- scalar save-store slot
	vmovdqa	0(%rsp), %ymm3
	vmovdqu	%ymm3, (%rdi)
	movq	56(%rsp), %rcx
	leaq	(%rcx), %rsp
	vzeroupper
	ret
	.size	align32, .-align32
	.section	.note.GNU-stack,"",@progbits
