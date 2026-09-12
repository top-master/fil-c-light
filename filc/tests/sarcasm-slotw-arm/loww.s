	.text
	.globl	loww
	.type	loww, %function
loww:                           ;! unsigned(size_t)
	sub	sp, sp, #16
	str	x0, [sp]
	ldr	w0, [sp]
	uxth	w0, w0
	add	sp, sp, #16
	ret
	.size	loww, .-loww
	.section	.note.GNU-stack,"",@progbits
