	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr, long)
	kmovw	%esi, %k1
	vpcompressq	%zmm0, (%rdi){%k1}
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
