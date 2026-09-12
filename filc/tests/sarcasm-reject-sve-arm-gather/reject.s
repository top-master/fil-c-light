/* An SVE gather load (z register + governing predicate) must be rejected: sarcasm supports NEON/AdvSIMD only. */
	.arch armv8-a
	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	ld1d	{z0.d}, p0/z, [x0]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
