/* SVE vector arithmetic must be rejected: sarcasm supports NEON/AdvSIMD only. */
	.arch armv8-a
	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	add	z0.s, z0.s, z1.s
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
