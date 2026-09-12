	.arch armv8-a
	.text
	.global	get
	.type	get, %function
get:                            ;! unsigned(ptr, size_t)
	ldrb	w0, [x0, x1]
	ret
	.size	get, .-get
