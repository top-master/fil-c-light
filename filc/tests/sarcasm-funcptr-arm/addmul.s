	.file	"addmul.c"
	.text
	.globl	addmul
	.type	addmul, %function
addmul:                         ;! long(long, long, long)
	mul	x0, x0, x1
	add	x0, x0, x2
	ret
	.size	addmul, .-addmul
	.section	.note.GNU-stack,"",@progbits
