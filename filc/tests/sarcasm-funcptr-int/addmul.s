	.intel_syntax noprefix
	.text
	.globl	addmul
	.type	addmul, @function
addmul:                         ;! long(long, long, long)
	mov	rax, rdi
	imul	rax, rsi
	add	rax, rdx
	ret
	.size	addmul, .-addmul
	.section	.note.GNU-stack,"",@progbits
