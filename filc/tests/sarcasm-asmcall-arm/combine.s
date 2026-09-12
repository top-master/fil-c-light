	.arch armv8-a
	.file	"combine.c"
	.text
	.global	sumsq
	.type	sumsq, %function
sumsq:                          ;! long(long, long)
	stp	x19, x20, [sp, -32]!
	str	x30, [sp, 16]
	mov	x19, x1
	bl	square          ;! long(long)
	mov	x20, x0
	mov	x0, x19
	bl	square          ;! long(long)
	add	x0, x0, x20
	ldr	x30, [sp, 16]
	ldp	x19, x20, [sp], 32
	ret
	.size	sumsq, .-sumsq
	.section	.note.GNU-stack,"",@progbits
