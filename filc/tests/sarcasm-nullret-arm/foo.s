	.arch armv8-a
	.text
	.global	foo
	.type	foo, %function
foo:                            ;! ptr(ptr)
	ldr	x0, [x0]
	ret
	.size	foo, .-foo
