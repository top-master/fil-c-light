	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr, long)
	# {k}-masked 64-byte load from a special (zweak) object: the bounds slow path traps (special objects have upper==lower).
	kmovw	%esi, %k1
	vmovdqu32	(%rdi), %zmm0{%k1}{z}
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
