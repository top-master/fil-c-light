	.text
	.globl	f
	.type	f, @function
f:                              ;! long()
	# `lock addq` on a stack slot: add IS a modeled memory-destination RMW
	# (lockAllows), but the frame rewrite runs first and virtualizes the slot
	# into a pseudo-register — without this rejection the locked memory RMW
	# would silently degenerate into an UNLOCKED register RMW. A stack slot
	# is thread-confined, so `lock` there is meaningless: reject.
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	$0, -8(%rbp)
	lock addq	$1, -8(%rbp)
	movq	-8(%rbp), %rax
	leave
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
