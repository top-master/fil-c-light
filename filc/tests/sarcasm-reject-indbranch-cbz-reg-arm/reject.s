/* A compare-and-branch whose target is a register (`cbz xN, xM`) has no
   provable target and is rejected (a register-target conditional branch is
   classified like any other indirect branch). */
	.text
	.global	f
	.type	f, %function
f:                              ;! void(ptr)
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	cbz	x0, x8
	ldp	x29, x30, [sp], 16
	ret
	.size	f, .-f
