	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 6-byte far-pointer load (4-byte offset + 2-byte selector); the bounds check fires before execution, so no FS-base clobbering happens. Load form.
	lfs	16(%rdi), %eax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
