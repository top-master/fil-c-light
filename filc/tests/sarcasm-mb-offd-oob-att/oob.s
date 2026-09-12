	.text
# The dec8x offload window's upper bound is enforced: a by-address access
# at the window's top edge (%rsp+448 of the (offd, %rsp + 192, %rsp + 448)
# window) traps. The base is derived exactly like the .pl's
# (`lea 192+128(%rsp)` then `add $128`, landing one full window past the
# ciphertext half), so this also pins that the window is 256 bytes, not
# larger. (The lower edge is covered by construction: bases below %rsp+192
# wrap to huge unsigned offsets in the same check.)
	.globl	mboob_run
	.type	mboob_run, @function
mboob_run:                      ;! void()
	movq	%rsp, %rax
	subq	$256, %rsp
	andq	$-256, %rsp
	subq	$192, %rsp
	movq	%rax, 16(%rsp)
	leaq	192+128(%rsp), %rbx		# ciphertext half @ +320
	addq	$128, %rbx			# -> +448: one past the window
	vmovdqu	(%rbx), %xmm0	#! stack buffer (offd, %rsp + 192, %rsp + 448)
	movq	16(%rsp), %rax
	leaq	(%rax), %rsp
	ret
	.size	mboob_run, .-mboob_run
	.section	.note.GNU-stack,"",@progbits
