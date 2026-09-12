	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# vcvtpd2ps with a bare unsized memory source is ambiguous (16, 32, or
	# 64 bytes depending on the dest width); must be cleanly rejected
	# rather than guessing a check width.
	vcvtpd2ps	(%rdi), %xmm0
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
