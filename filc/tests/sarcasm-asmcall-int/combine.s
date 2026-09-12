	.intel_syntax noprefix
	.text
	.globl	sumsq
	.type	sumsq, @function
sumsq:                          ;! long(long, long)
	push	rbx
	push	r12
	mov	rbx, rdi
	mov	r12, rsi
	call	square          ;! long(long)
	mov	rbx, rax
	mov	rdi, r12
	call	square          ;! long(long)
	add	rax, rbx
	pop	r12
	pop	rbx
	ret
	.size	sumsq, .-sumsq
	.section	.note.GNU-stack,"",@progbits
