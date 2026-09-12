	.text
	.globl	f
	.type	f, @function
f:                              ;! long()
	# cmpxchg8b on a stack-frame slot: the frame rewrite virtualizes stack
	# slots into pseudo-REGISTERS, and cmpxchg8b has no register form to
	# virtualize into (GPR-only stack slots are never materialized), so this
	# must be a clean compile-time rejection, not a mis-sized slot.
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	$1, %rax
	movq	$2, %rdx
	movq	$3, %rbx
	movq	$4, %rcx
	cmpxchg8b	-8(%rbp)
	movq	-8(%rbp), %rax
	leave
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
