	.text
# Plain (unannotated) buffer-interior addressing works when statically
# resolvable: a `leaq K(%rsp)` base used straight (no ALU, no index)
# lets sarcasm resolve the access to its frame slot, with no annotation
# needed. This is the boundary the aesni-mb annotations respect: the
# SARCASM path annotates exactly the DYNAMIC shapes (the ($offload)
# computed-base ping-pong and the indexed tails), while statically
# resolvable traffic -- on either path -- carries no annotation. GPR
# and vector widths, loads and stores.
	.globl	mbplain_run
	.type	mbplain_run, @function
mbplain_run:                    ;! void(ptr, ptr)
	# %rdi = src (48B), %rsi = dst (48B).
	subq	$64, %rsp
	movdqu	0(%rdi), %xmm0
	movdqu	%xmm0, 0(%rsp)
	movq	16(%rdi), %rax
	movq	%rax, 16(%rsp)
	movq	24(%rdi), %rax
	movq	%rax, 24(%rsp)
	movq	32(%rdi), %rax
	movq	%rax, 32(%rsp)
	movdqu	40(%rdi), %xmm0
	movdqu	%xmm0, 40(%rsp)
	leaq	0(%rsp), %rbx
	movdqu	(%rbx), %xmm0
	movdqu	%xmm0, 0(%rsi)
	leaq	16(%rsp), %r10
	movq	(%r10), %rax
	movq	%rax, 16(%rsi)
	movq	8(%r10), %rax
	movq	%rax, 24(%rsi)
	leaq	32(%rsp), %r11
	movq	(%r11), %rax
	movq	%rax, 32(%rsi)
	leaq	40(%rsp), %r8
	movdqu	(%r8), %xmm0
	movdqu	%xmm0, 40(%rsi)
	addq	$64, %rsp
	ret
	.size	mbplain_run, .-mbplain_run
	.section	.note.GNU-stack,"",@progbits
