/* Load-link/store-conditional (the ARMv8.0 baseline atomic primitive — no
   LSE required): the CAS retry loop on a plain cell, in the ldxr/stxr,
   ldxrb/stxrb and ldaxr/stlxr forms. A lost RMW shows up as a short final
   count in the C driver's multithreaded hammering. */

	.text

	.globl	llsc_inc
	.type	llsc_inc, %function
llsc_inc:                       ;! void(ptr)
	# one atomic increment of a long cell via the LL/SC retry loop
.L1:
	ldxr	x8, [x0]
	add	x8, x8, #1
	stxr	w9, x8, [x0]
	cbnz	w9, .L1
	ret
	.size	llsc_inc, .-llsc_inc

	.globl	llsc_inc_b
	.type	llsc_inc_b, %function
llsc_inc_b:                     ;! void(ptr)
	# same on a byte cell (8-bit LL/SC)
.L2:
	ldxrb	w8, [x0]
	add	w8, w8, #1
	stxrb	w9, w8, [x0]
	cbnz	w9, .L2
	ret
	.size	llsc_inc_b, .-llsc_inc_b

	.globl	llsc_add_acq
	.type	llsc_add_acq, %function
llsc_add_acq:                   ;! long(ptr, long)
	# the acquire/release forms: atomically add x1 to the cell, return the
	# OLD value
.L3:
	ldaxr	x8, [x0]
	add	x10, x8, x1
	stlxr	w9, x10, [x0]
	cbnz	w9, .L3
	mov	x0, x8
	ret
	.size	llsc_add_acq, .-llsc_add_acq

	.globl	llsc_cas
	.type	llsc_cas, %function
llsc_cas:                       ;! long(ptr, long, long)
	# compare-exchange built from LL/SC: x0 = cell, x1 = expected,
	# x2 = desired; returns 1 iff exchanged
	mov	x10, x0
.L4:
	ldxr	x8, [x10]
	cmp	x8, x1
	b.ne	.L5
	stxr	w9, x2, [x10]
	cbnz	w9, .L4
	mov	x0, #1
	ret
.L5:
	mov	x0, #0
	ret
	.size	llsc_cas, .-llsc_cas

	.section	.note.GNU-stack,"",@progbits
