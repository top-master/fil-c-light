	.arch_extension lse
	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	# 16-byte LSE casp (an atomic RMW is a write) at the upper bound of the 16-byte object.
	mov	x8, #0
	mov	x9, #0
	mov	x10, #0
	mov	x11, #0
	casp	x8, x9, x10, x11, [x0]
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
