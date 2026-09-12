	.text
# Regression proof for sarcasm's absolute-alignment identity for computed
# buffer bases (the aesni-mb dec8x `xorq $0x80, %base` toggle): a 256-byte
# buffer (%rsp+192..%rsp+448) addressed through a base that flips between
# its halves. Without the identity (output-frame dynamic alignment to the
# governing and's modulus), the flipped base lands outside the lowered
# group for some entry alignments and vector traffic through it traps or
# misbehaves. The C harness sweeps 64 entry depths (every mod-64 residue
# twice over), so any residue-dependent lowering fails deterministically.
# Both GPR and vector traffic ride the flipped base each iteration.
	.globl	mbxor_run
	.type	mbxor_run, @function
mbxor_run:                      ;! void(ptr, ptr)
	# %rdi = src (64B: 32B per half), %rsi = dst (64B).
	movq	%rsp, %rax
	subq	$256, %rsp
	andq	$-256, %rsp
	subq	$192, %rsp
	movq	%rax, 16(%rsp)			# saved-rsp carrier
	leaq	192+128(%rsp), %rbx		# base (half A @ +320)
	# stage half A from src[0..32)
	movdqu	0(%rdi), %xmm0
	vmovdqu	%xmm0, 0x00(%rbx)	#! stack buffer (xortog, %rsp + 192, %rsp + 448)
	movq	16(%rdi), %rcx
	movq	%rcx, 0x10(%rbx)	#! stack buffer (xortog, %rsp + 192, %rsp + 448)
	movq	24(%rdi), %rcx
	movq	%rcx, 0x18(%rbx)	#! stack buffer (xortog, %rsp + 192, %rsp + 448)
	xorq	$0x80, %rbx			# -> half B @ +192
	# stage half B from src[32..64)
	movdqu	32(%rdi), %xmm0
	vmovdqu	%xmm0, 0x00(%rbx)	#! stack buffer (xortog, %rsp + 192, %rsp + 448)
	movq	48(%rdi), %rcx
	movq	%rcx, 0x10(%rbx)	#! stack buffer (xortog, %rsp + 192, %rsp + 448)
	movq	56(%rdi), %rcx
	movq	%rcx, 0x18(%rbx)	#! stack buffer (xortog, %rsp + 192, %rsp + 448)
	xorq	$0x80, %rbx			# -> half A @ +320
	# drain half A to dst[0..32)
	vmovdqu	0x00(%rbx), %xmm0	#! stack buffer (xortog, %rsp + 192, %rsp + 448)
	movdqu	%xmm0, 0(%rsi)
	movq	0x10(%rbx), %rcx	#! stack buffer (xortog, %rsp + 192, %rsp + 448)
	movq	%rcx, 16(%rsi)
	movq	0x18(%rbx), %rcx	#! stack buffer (xortog, %rsp + 192, %rsp + 448)
	movq	%rcx, 24(%rsi)
	xorq	$0x80, %rbx			# -> half B @ +192
	# drain half B to dst[32..64)
	vmovdqu	0x00(%rbx), %xmm0	#! stack buffer (xortog, %rsp + 192, %rsp + 448)
	movdqu	%xmm0, 32(%rsi)
	movq	0x10(%rbx), %rcx	#! stack buffer (xortog, %rsp + 192, %rsp + 448)
	movq	%rcx, 48(%rsi)
	movq	0x18(%rbx), %rcx	#! stack buffer (xortog, %rsp + 192, %rsp + 448)
	movq	%rcx, 56(%rsi)
	movq	16(%rsp), %rax			# carrier recovery
	leaq	(%rax), %rsp
	ret
	.size	mbxor_run, .-mbxor_run
	.section	.note.GNU-stack,"",@progbits
