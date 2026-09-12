	# `.section .init` content is limited to annotated direct void() calls;
	# an unannotated call cannot be marshalled (and a non-call instruction
	# has no business there either), so this is a clean rejection.
	.section	.init
	call	setup
	.text
	.globl	f
	.type	f, @function
f:                              #! void()
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
