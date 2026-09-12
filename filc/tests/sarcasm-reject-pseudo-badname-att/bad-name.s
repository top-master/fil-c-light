	.text
	# `%fil_foo-bar` is not a valid pseudoregister name (ident must match
	# [0-9a-zA-Z_]+).
	.globl	pseudo_bad_name
	.type	pseudo_bad_name, @function
pseudo_bad_name:                ;! long(long)
	endbr64
	movq	%rdi, %fil_foo-bar
	movq	%rdi, %rax
	ret
	.size	pseudo_bad_name, .-pseudo_bad_name
	.section	.note.GNU-stack,"",@progbits
