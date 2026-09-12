	.file	"llp.c"
	.text
	.global	llp
	.type	llp, %function
llp:                            ;! long(long, long, ptr)
	ldr	x3, [x2]
	add	x0, x3, x0
	add	x0, x0, x1
	ret
	.size	llp, .-llp
	.section	.note.GNU-stack,"",@progbits
