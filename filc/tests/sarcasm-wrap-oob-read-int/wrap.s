	.intel_syntax noprefix
	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr, long)
	# Intel-syntax twin of sarcasm-wrap-oob-read-att (the eff+size overflow
	# hole: eff = -8 wraps the naive eff+8 upper check to 0).
	movq	rax, [rdi+rsi]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
