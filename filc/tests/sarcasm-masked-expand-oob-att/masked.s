	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr, long)
	kmovw	%esi, %k1
	vpexpandq	(%rdi), %zmm0{%k1}
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
