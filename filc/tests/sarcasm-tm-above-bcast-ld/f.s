	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# embedded-broadcast {1to16}: reads ONE 4-byte element and broadcasts it; the bounds check covers the 4-byte element unconditionally. Load form.
	vaddps	16(%rdi){1to16}, %zmm0, %zmm0
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
