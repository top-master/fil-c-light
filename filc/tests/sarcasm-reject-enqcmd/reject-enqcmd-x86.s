	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# Unknown mnemonic with a memory operand: the access width is unknowable,
	# so any default-width check would be unsound. Reject.
	enqcmd	(%rdi), %rax
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
