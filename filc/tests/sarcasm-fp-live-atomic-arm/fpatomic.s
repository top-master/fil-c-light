/* q0, q8, q16 and q31 (16 bytes each) are live across annotated ATOMIC
   pointer operations: both the `;! atomic store ptr` runtime call and the
   `;! atomic load store ptr` compare-exchange loop (which contains an
   atomic-load runtime call and a compare-exchange runtime call per
   iteration) must spill/restore all live vector state at full width — the
   runtime calls can allocate and run GC code, which clobbers caller-saved
   NEON registers. */

	.arch_extension lse
	.text

	.globl	f_atomic_store
	.type	f_atomic_store, %function
f_atomic_store:                 ;! long(ptr, ptr)
	stp	x29, x30, [sp, #-16]!
	mov	x29, sp
	ldr	q0, [x1]
	ldr	q8, [x1, #16]
	ldr	q16, [x1, #32]
	ldr	q31, [x1, #48]
	ldr	x2, [x0, #8]    ;! load ptr
	str	x2, [x0]        ;! atomic store ptr
	umov	x4, v0.d[0]
	umov	x5, v0.d[1]
	add	x0, x4, x5
	umov	x4, v8.d[0]
	umov	x5, v8.d[1]
	add	x0, x0, x4
	add	x0, x0, x5
	umov	x4, v16.d[0]
	umov	x5, v16.d[1]
	add	x0, x0, x4
	add	x0, x0, x5
	umov	x4, v31.d[0]
	umov	x5, v31.d[1]
	add	x0, x0, x4
	add	x0, x0, x5
	mov	sp, x29
	ldp	x29, x30, [sp], #16
	ret
	.size	f_atomic_store, .-f_atomic_store

	.globl	f_atomic_rmw
	.type	f_atomic_rmw, %function
f_atomic_rmw:                   ;! long(ptr, ptr)
	stp	x29, x30, [sp, #-16]!
	mov	x29, sp
	ldr	q0, [x1]
	ldr	q8, [x1, #16]
	ldr	q16, [x1, #32]
	ldr	q31, [x1, #48]
	mov	x2, #0
	ldadd	x2, x8, [x0]    ;! atomic load store ptr
	umov	x4, v0.d[0]
	umov	x5, v0.d[1]
	add	x0, x4, x5
	umov	x4, v8.d[0]
	umov	x5, v8.d[1]
	add	x0, x0, x4
	add	x0, x0, x5
	umov	x4, v16.d[0]
	umov	x5, v16.d[1]
	add	x0, x0, x4
	add	x0, x0, x5
	umov	x4, v31.d[0]
	umov	x5, v31.d[1]
	add	x0, x0, x4
	add	x0, x0, x5
	mov	sp, x29
	ldp	x29, x30, [sp], #16
	ret
	.size	f_atomic_rmw, .-f_atomic_rmw

	.section	.note.GNU-stack,"",@progbits
