	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr, long)
	# eff = buf + idx = 2^64-1; eff+10 wraps, so a naive eff+size check would pass. The overflow-free check traps cleanly (huge eff attributes as ptr >= upper). Load form.
	fldt	(%rdi,%rsi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
