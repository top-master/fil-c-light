	.intel_syntax noprefix
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(long)
	enter	16, 0
	mov	rax, rdi
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
