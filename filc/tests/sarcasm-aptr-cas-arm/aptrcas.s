/* `;! atomic ptr` on cas: pointer compare-exchange through the runtime. The
   compare register goes in with the expected value and comes out with the
   old slot value AS A POINTER (capability included — the C driver
   dereferences it); NZCV is recomputed as (expected - old) so a following
   cset/b.eq behaves like x86's cmpxchg flags (the hardware cas itself sets
   no flags — the recompute is sarcasm's contract for this annotation). */

	.arch_extension lse
	.text

	.globl	ap_cas
	.type	ap_cas, %function
ap_cas:                         ;! ptr(ptr, ptr)
	# x0 -> pair: [x0] = the CAS slot, [x0+8] = the new value (a pointer).
	# x1 = expected. Returns the old value (with its capability).
	ldr	x8, [x0, #8]    ;! load ptr
	mov	x9, x1
	cas	x9, x8, [x0]    ;! atomic ptr
	mov	x0, x9
	ret
	.size	ap_cas, .-ap_cas

	.globl	ap_casal
	.type	ap_casal, %function
ap_casal:                       ;! ptr(ptr, ptr)
	# same, acquire-release ordering
	ldr	x8, [x0, #8]    ;! load ptr
	mov	x9, x1
	casal	x9, x8, [x0]    ;! atomic ptr
	mov	x0, x9
	ret
	.size	ap_casal, .-ap_casal

	.globl	ap_cas_zf
	.type	ap_cas_zf, %function
ap_cas_zf:                      ;! long(ptr, ptr)
	# returns 1 iff the exchange happened: a flag consumer immediately
	# after the annotated cas must behave natively (cmpxchg-style).
	ldr	x8, [x0, #8]    ;! load ptr
	mov	x9, x1
	cas	x9, x8, [x0]    ;! atomic ptr
	cset	x0, eq
	ret
	.size	ap_cas_zf, .-ap_cas_zf

	.globl	ap_cas_beq
	.type	ap_cas_beq, %function
ap_cas_beq:                     ;! long(ptr, ptr)
	# same through a BRANCH flag consumer
	ldr	x8, [x0, #8]    ;! load ptr
	mov	x9, x1
	cas	x9, x8, [x0]    ;! atomic ptr
	b.eq	.Lmatched
	mov	x0, #0
	ret
.Lmatched:
	mov	x0, #1
	ret
	.size	ap_cas_beq, .-ap_cas_beq

	.globl	ap_add
	.type	ap_add, %function
ap_add:                         ;! ptr(ptr, long)
	# the compare-exchange retry idiom: atomically add x1 to the pointer
	# slot, return the old pointer (with capability).
	ldr	x9, [x0]        ;! atomic load ptr
.L1:
	add	x10, x9, x1
	mov	x8, x9
	cas	x8, x10, [x0]   ;! atomic ptr
	mov	x9, x8
	b.ne	.L1
	mov	x0, x8
	ret
	.size	ap_add, .-ap_add

	.section	.note.GNU-stack,"",@progbits
