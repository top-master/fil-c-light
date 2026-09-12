	.text
	.p2align 4
	.global	foo
	.type	foo, %function
foo:                            ;! long(ptr, long)
	mov	x8, x0
	add	x0, x1, #1
	blr	x8 ;! ptr(long)
	ldr	x0, [x0]
	add	x0, x0, #67
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
