	.arch armv8-a
	.text
	.global	deref_int
	.type	deref_int, %function
deref_int:                      ;! int(int)
	ldr	w0, [x0]
	ret
	.size	deref_int, .-deref_int
