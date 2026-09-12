/* q0 (16 bytes) and q8 (16 bytes) are live across an annotated store-ptr:
   the GC write barrier can call into the runtime (and allocation/GC code
   clobbers caller-saved vector state), so the instrumented barrier must
   spill/restore both q registers at their full 16-byte width. */
	.arch armv8-a
	.text
	.globl	f_barrier
	.type	f_barrier, %function
f_barrier:                      ;! long(ptr, ptr)
	stp	x29, x30, [sp, #-16]!
	mov	x29, sp
	ldr	q0, [x1]
	ldr	q8, [x1, #16]
	ldr	x2, [x0, #8]    ;! load ptr
	str	x2, [x0]        ;! store ptr
	umov	x4, v0.d[0]
	umov	x5, v0.d[1]
	add	x0, x4, x5
	umov	x4, v8.d[0]
	umov	x5, v8.d[1]
	add	x0, x0, x4
	add	x0, x0, x5
	mov	sp, x29
	ldp	x29, x30, [sp], #16
	ret
	.size	f_barrier, .-f_barrier
	.section	.note.GNU-stack,"",@progbits
