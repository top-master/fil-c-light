	.text
	.globl	cvtwid_u
	.type	cvtwid_u, @function
cvtwid_u:                       ;! void(ptr, ptr)
	# vcvtudq2pd zmm, m256: the memory source is HALF the destination width
	# (8 dwords -> 8 doubles). A 32-byte load of a 32-byte object must pass;
	# the old over-check at the full 64-byte destination width would trap.
	vcvtudq2pd	(%rdi), %zmm0
	vmovdqu64	%zmm0, (%rsi)
	ret
	.size	cvtwid_u, .-cvtwid_u
	.globl	cvtwid_s
	.type	cvtwid_s, @function
cvtwid_s:                       ;! void(ptr, ptr)
	vcvtdq2pd	(%rdi), %zmm1
	vmovdqu64	%zmm1, (%rsi)
	ret
	.size	cvtwid_s, .-cvtwid_s
	.section	.note.GNU-stack,"",@progbits
