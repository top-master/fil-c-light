	.text
	# Alignment-requiring vector moves (movaps/movdqa) to a misaligned but
	# in-bounds address must still trap on alignment (the CPU requires it).
	.globl	movaps_misaligned
	.type	movaps_misaligned, @function
movaps_misaligned:              ;! void(ptr)
	endbr64
	movaps	(%rdi), %xmm0
	movaps	%xmm0, 1(%rdi)
	ret
	.size	movaps_misaligned, .-movaps_misaligned
	.section	.note.GNU-stack,"",@progbits
