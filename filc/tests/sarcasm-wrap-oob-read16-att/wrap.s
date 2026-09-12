	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr, long)
	# Wider-width (16-byte) variant of the eff+size overflow hole:
	# eff = -4 wraps eff+16 to 12.
	movdqu	(%rdi,%rsi), %xmm0
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
