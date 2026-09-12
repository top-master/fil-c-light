	.intel_syntax noprefix
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	# Regression test: an Intel PTR size annotation that contradicts the
	# register-determined memory access width must REJECT on a heap access.
	# `mov WORD PTR [rdi], rax` stores 8 bytes (rax), not 2; the WORD PTR
	# annotation is a lie that would under-size the bounds check.
	mov	WORD PTR [rdi], rax
	mov	rax, rdi
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
