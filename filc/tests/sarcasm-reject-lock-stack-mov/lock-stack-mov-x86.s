	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# `lock` on a stack-frame access can never be honored: the frame rewrite
	# virtualizes the slot into a pseudo-register (or materializes it into the
	# thread-confined synthesized frame) BEFORE classify's lockAllows check
	# runs, so the prefix would be silently elided. Reject instead — a stack
	# slot is thread-confined, so `lock` there is meaningless. (The heap form
	# `lock movq %rsi, (%rdi)` is rejected by classify for a different reason:
	# mov is not a memory-destination RMW.)
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	lock movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	leave
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
