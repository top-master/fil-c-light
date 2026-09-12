// The join at .L2 merges x3's two defs into one register web, but the defs copy
// from two different pointer origins (x0 vs x1). One temp cannot carry two
// capabilities, so pointer-flow analysis never converges and sarcasm must reject
// this cleanly: "pointer-flow analysis does not converge: ...".
	.text
	.global	f
	.type	f, %function
f:                              ;! void(ptr, ptr)
	ldr	x2, [x0]        // scalar condition (plain load, not a pointer source)
	cbz	x2, .L1
	mov	x3, x0
	b	.L2
.L1:
	mov	x3, x1
.L2:
	str	x0, [x3]        ;! store ptr
	ret
	.size	f, .-f
