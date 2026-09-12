/* The ;! load ptr annotation is only valid on a 64-bit scalar GPR load; a
   NEON q0 destination cannot carry a pointer capability, so this must be
   rejected. */
	.arch armv8-a
	.text
	.globl	f
	.type	f, %function
f:                              ;! void(ptr)
	ldr	q0, [x0]        ;! load ptr
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
