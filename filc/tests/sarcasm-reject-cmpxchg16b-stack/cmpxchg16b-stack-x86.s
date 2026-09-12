	.text
	.globl	f
	.type	f, @function
f:                              ;! long()
	# cmpxchg16b on a stack-frame slot: like cmpxchg8b, it has no register
	# form to virtualize the slot into (and a 16-byte GPR-only stack slot is
	# never materialized), so the frame rewrite rejects it cleanly.
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	$1, %rax
	movq	$2, %rdx
	movq	$3, %rbx
	movq	$4, %rcx
	cmpxchg16b	-16(%rbp)
	movq	-16(%rbp), %rax
	leave
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
