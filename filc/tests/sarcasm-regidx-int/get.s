	.intel_syntax noprefix
	.text
	.globl	get
	.type	get, @function
get:                            ;! unsigned(ptr, size_t)
	movzx	eax, BYTE PTR [rdi+rsi]
	ret
	.size	get, .-get
	.section	.note.GNU-stack,"",@progbits
