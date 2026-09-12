	.intel_syntax noprefix
	.text
	.globl	zx
	.type	zx, @function
zx:                             ;! unsigned long(ptr)
	mov	rax, [rdi]
	sal	rax, 40
	mov	eax, eax
	ret
	.size	zx, .-zx
	.section	.note.GNU-stack,"",@progbits
