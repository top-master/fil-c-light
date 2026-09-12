	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# ldtilecfg loads the 64-byte AMX tile configuration: same AMX reject class.
	ldtilecfg	(%rdi)
	movq	%rdi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
