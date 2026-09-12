/* SVE predicate initialization must be rejected: sarcasm supports NEON/AdvSIMD only. */
	.arch armv8-a
	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	ptrue	p0.b
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
