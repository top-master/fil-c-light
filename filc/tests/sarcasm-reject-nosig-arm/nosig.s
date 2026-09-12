	.arch armv8-a
	.text
	.global	foo
	.type	foo, %function
foo:
	mov	x1, x0
	ret
	.size	foo, .-foo
