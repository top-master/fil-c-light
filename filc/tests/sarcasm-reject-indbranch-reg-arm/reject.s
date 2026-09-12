/* A raw register branch (`b xN`, e.g. a computed goto or a switch jump table)
   has no provable target and is rejected, exactly like `br xN`. */
	.text
	.global	f
	.type	f, %function
f:                              ;! void(ptr)
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	b	x8
	ldp	x29, x30, [sp], 16
	ret
	.size	f, .-f
