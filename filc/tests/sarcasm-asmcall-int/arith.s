	.intel_syntax noprefix
	.text
	.globl	square
	.type	square, @function
square:                         ;! long(long)
	mov	rax, rdi
	imul	rax, rdi
	ret
	.size	square, .-square
	.globl	cube
	.type	cube, @function
cube:                           ;! long(long)
	mov	rax, rdi
	imul	rax, rdi
	imul	rax, rdi
	ret
	.size	cube, .-cube
	.section	.note.GNU-stack,"",@progbits
