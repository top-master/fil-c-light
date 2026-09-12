	.file	"arith.c"
	.text
	.globl	square
	.type	square, @function
square:                         ;! long(long)
	movq	%rdi, %rax
	imulq	%rdi, %rax
	ret
	.size	square, .-square
	.globl	cube
	.type	cube, @function
cube:                           ;! long(long)
	movq	%rdi, %rax
	imulq	%rdi, %rax
	imulq	%rdi, %rax
	ret
	.size	cube, .-cube
	.section	.note.GNU-stack,"",@progbits
