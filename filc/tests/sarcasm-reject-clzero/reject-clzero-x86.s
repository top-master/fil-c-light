	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# clzero stores to an implicit memory operand (the 64-byte cache line
	# addressed by rax) that cannot be bounds-checked: reject.
	movq	%rdi, %rax
	clzero
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
