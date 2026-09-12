	.arch_extension lse
	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr, long)
	# 8-byte LSE swp (an atomic RMW is a write) at the upper bound of the 16-byte object.
	swp	x1, x8, [x0]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
