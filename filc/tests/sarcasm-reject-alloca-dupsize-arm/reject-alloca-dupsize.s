	.text
	.global	f
	.type	f, %function
f:                              ;! void(ptr)
	sub	sp, sp, x1 ;! alloca size (a)
	sub	sp, sp, x1 ;! alloca size (a)
	mov	x0, sp ;! alloca result (a)
	ret
	.size	f, .-f
