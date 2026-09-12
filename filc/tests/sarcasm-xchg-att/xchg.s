# XCHG register-to-register: BOTH operands are read and written (each receives
# the other's value). The swaps below run under register pressure (four webs
# live across them, colored apart from the exchanged pair) -- the old
# conservative first-register-def model miscompiled exactly this shape into
# allocation-order-dependent garbage: one side of each swap silently kept or
# lost its value.
	.text
	.globl	xchg_pairs
	.type	xchg_pairs, @function
xchg_pairs:                     ;! void(ptr, ptr)
	endbr64
	movq	%rdi, %rbx
	# Pair 1: the classic operand order.
	movq	(%rdi), %rax
	movq	8(%rdi), %rcx
	movq	$0x5555555555555555, %r12
	movq	$0x6666666666666666, %r13
	movq	$0x7777777777777777, %r14
	movq	$0x8888888888888888, %r15
	xchgq	%rax, %rcx
	# Pair 2: the other operand order (the first-named register receives the
	# SECOND operand's value).
	movq	16(%rdi), %r8
	movq	24(%rdi), %r9
	xchgq	%r9, %r8
	# Store all four results, plus the pressure values so they must survive.
	movq	%rax, (%rsi)
	movq	%rcx, 8(%rsi)
	movq	%r8, 16(%rsi)
	movq	%r9, 24(%rsi)
	movq	%r12, 32(%rsi)
	movq	%r13, 40(%rsi)
	movq	%r14, 48(%rsi)
	movq	%r15, 56(%rsi)
	movq	%rbx, %rax
	ret
	.size	xchg_pairs, .-xchg_pairs
	.section	.note.GNU-stack,"",@progbits
