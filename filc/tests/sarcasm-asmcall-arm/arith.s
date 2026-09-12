	.arch armv8-a
	.file	"arith.c"
	.text
	.global	square
	.type	square, %function
square:                         ;! long(long)
	mul	x0, x0, x0
	ret
	.size	square, .-square
	.global	cube
	.type	cube, %function
cube:                           ;! long(long)
	mul	x1, x0, x0
	mul	x0, x1, x0
	ret
	.size	cube, .-cube
	.section	.note.GNU-stack,"",@progbits
