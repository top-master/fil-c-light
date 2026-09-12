	.arch armv8-a
	.text
	.global	bar
	.type	bar, %function
bar:                            ;! ptr(ptr)
	ldr	x0, [x0]        ;! load ptr
	ret
	.size	bar, .-bar
