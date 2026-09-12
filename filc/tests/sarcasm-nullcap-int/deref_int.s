	.intel_syntax noprefix
	.text
	.globl	deref_int
	.type	deref_int, @function
deref_int:                      ;! int(int)
	mov	eax, [rdi]
	ret
	.size	deref_int, .-deref_int
	.section	.note.GNU-stack,"",@progbits
