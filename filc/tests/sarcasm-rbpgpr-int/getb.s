	.intel_syntax noprefix
	.text
	.globl	getb
	.type	getb, @function
getb:                           ;! unsigned(ptr, size_t)
	push	rbp
	mov	rbp, rdi
	lea	rax, [rbp+rsi]
	movzx	eax, BYTE PTR [rax]
	pop	rbp
	ret
	.size	getb, .-getb
	.section	.note.GNU-stack,"",@progbits
