/* Nine float arguments at a callsite: at most 8 FP arguments (v0..v7). */
	.text
	.global	foo
	.type	foo, %function
foo:                            ;! int()
	bl	ext ;! void(float, float, float, float, float, float, float, float, float)
	ret
	.size	foo, .-foo
