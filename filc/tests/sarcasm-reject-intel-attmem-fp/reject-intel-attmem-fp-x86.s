	.intel_syntax noprefix
	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# Same AT&T-style-parens bypass, but on an AVX512 load: the 64-byte
	# memory access would have gone completely unchecked.
	vmovdqu64	(%rdi), %zmm0
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
