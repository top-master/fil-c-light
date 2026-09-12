	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr, long)
	# Write variant of the eff+size overflow hole (eff = -8 wraps eff+8 to 0).
	movq	%rax, (%rdi,%rsi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
