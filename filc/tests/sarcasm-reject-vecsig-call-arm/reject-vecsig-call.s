/* A vector type in a CALLSITE annotation is rejected on arm64 just like in an
   entry signature. */
	.text
	.global	foo
	.type	foo, %function
foo:                            ;! int(ptr)
	bl	ext ;! vec4(vec4)
	ret
	.size	foo, .-foo
