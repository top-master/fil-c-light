	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr, long)
	# {k}-masked 64-byte store to a freed object: the CanWrite aux-flags test (READONLY|FREE) fires before the bounds slow path, so the runtime attributes this as a free-object access (size=0 origin) — exactly like the Fil-C compiler's masked-store check.
	kmovw	%esi, %k1
	vmovdqu32	%zmm0, (%rdi){%k1}
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
