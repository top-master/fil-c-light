	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# lgdt is a privileged descriptor-table load (#GP at CPL > 0): reject.
	lgdt	(%rdi)
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
