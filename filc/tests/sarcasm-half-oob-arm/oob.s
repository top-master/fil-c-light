/* The 2-byte fp16 h0 store at offset 15 of a 16-byte object covers [15, 17) — out of bounds. */
	.arch armv8-a
	.text
	.globl	storeh
	.type	storeh, %function
storeh:                            ;! void(ptr)
	str	h0, [x0, #15]
	ret
	.size	storeh, .-storeh
	.section	.note.GNU-stack,"",@progbits
