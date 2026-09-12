	.text
	.global	f
	.type	f, %function
f:                              ;! void(ptr)
	mov	x0, sp ;! alloca result (a)
	ret
	.size	f, .-f
