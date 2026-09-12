	.file	"rmw.c"
	.text
	.p2align 4
	.globl	f
	.type	f, %function
f:                              ;! long(ptr, ptr)
	ldr	x9, [x0]
	ldr	x10, [x1]
	add	x9, x9, x10
	ldr	x10, [x0, 8]	;! load ptr
	ldr	x10, [x10]
	bfi	x9, x10, 32, 32
	lsr	x10, x9, 32
	movk	x9, 0, lsl 32
	movk	x9, 0, lsl 48
	add	x0, x9, x10
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
