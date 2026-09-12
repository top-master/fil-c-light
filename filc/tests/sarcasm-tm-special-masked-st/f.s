	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr, long)
	# {k}-masked 64-byte store to a special (zweak) object: special is not in the CanWrite READONLY|FREE mask, so the bounds slow path traps (special objects have upper==lower).
	kmovw	%esi, %k1
	vmovdqu32	%zmm0, (%rdi){%k1}
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
