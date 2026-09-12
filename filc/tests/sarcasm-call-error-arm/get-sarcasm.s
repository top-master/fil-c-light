	.text
	.p2align 4
	.global	foo
	.type	foo, %function
foo:                            ;! int(ptr, size_t)
	ldr	x0, [x0, x1, lsl #3] ;! load ptr
	ldr	w0, [x0]
	ret
	.size	foo, .-foo
