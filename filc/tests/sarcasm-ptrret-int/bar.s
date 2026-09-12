	.intel_syntax noprefix
	.text
	.globl	bar
	.type	bar, @function
bar:                            ;! ptr(ptr)
	mov	rax, [rdi]      ;! load ptr
	ret
	.size	bar, .-bar
	.section	.note.GNU-stack,"",@progbits
