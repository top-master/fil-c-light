	.text
	.globl	get
	.type	get, @function
get:                            ;! unsigned(ptr, size_t)
	movzbl	(%rdi,%rsi), %eax
	ret
	.size	get, .-get
	.section	.note.GNU-stack,"",@progbits
