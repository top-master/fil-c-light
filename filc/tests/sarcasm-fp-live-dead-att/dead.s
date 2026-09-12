	.text
	.globl	dead_regs
	.type	dead_regs, @function
dead_regs:                      ;! long(long)
	# xmm2/xmm4 are WRITTEN before the loop but are DEAD across the loop's
	# pollchecks: they are overwritten (pxor) at the bottom of the loop body
	# and never read afterwards. The width-aware expansion therefore emits
	# NO save/restore movs at all around the pollcheck slow-path call (-S
	# verified: the call site is wrapped in nothing).
	movq	%rdi, %rax
	addsd	%xmm1, %xmm2
	mulsd	%xmm3, %xmm4
	testq	%rdi, %rdi
	je	.Ldone
.Lloop:
	pxor	%xmm2, %xmm2
	pxor	%xmm4, %xmm4
	subq	$1, %rax
	jne	.Lloop
.Ldone:
	ret
	.size	dead_regs, .-dead_regs
	.section	.note.GNU-stack,"",@progbits
