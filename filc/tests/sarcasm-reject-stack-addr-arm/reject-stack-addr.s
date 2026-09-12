	.text
	.global	f
	.type	f, %function
f:                              ;! void(void)
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	add	x1, sp, #8
	ldp	x29, x30, [sp], 16
	ret
	.size	f, .-f
