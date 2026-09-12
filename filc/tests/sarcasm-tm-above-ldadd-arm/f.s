	.arch_extension lse
	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr, long)
	# 4-byte LSE ldadd (an atomic RMW is a write) at the upper bound of the 16-byte object.
	ldadd	w1, w8, [x0]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
