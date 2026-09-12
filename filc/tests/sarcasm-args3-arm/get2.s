	.file	"get2.c"
	.text
	.global	get2
	.type	get2, %function
get2:                           ;! unsigned long(ptr, size_t, size_t)
	ldrb	w3, [x0, x1]
	ldrb	w4, [x0, x2]
	add	x0, x3, x4
	ret
	.size	get2, .-get2
	.section	.note.GNU-stack,"",@progbits
