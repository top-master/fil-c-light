/* Multithreaded stress building blocks: one atomic pointer RMW (+8 / -8)
   through the `;! atomic load store ptr` runtime compare-exchange loop — the
   capability rides through every hop — plus an atomic pointer load for the
   final dereference. */

	.arch_extension lse
	.text

	.globl	ap_lock_add8
	.type	ap_lock_add8, %function
ap_lock_add8:                   ;! void(ptr)
	# one atomic pointer RMW: slot += 8, capability preserved
	mov	x8, #8
	ldadd	x8, x9, [x0]    ;! atomic load store ptr
	ret
	.size	ap_lock_add8, .-ap_lock_add8

	.globl	ap_lock_dec8
	.type	ap_lock_dec8, %function
ap_lock_dec8:                   ;! void(ptr)
	mov	x8, #-8
	ldadd	x8, x9, [x0]    ;! atomic load store ptr
	ret
	.size	ap_lock_dec8, .-ap_lock_dec8

	.globl	ap_cas
	.type	ap_cas, %function
ap_cas:                         ;! ptr(ptr, ptr)
	# an annotated pointer compare-exchange for the CAS churn half:
	# x0 -> pair ([x0] = slot, [x0+8] = new value), x1 = expected
	ldr	x8, [x0, #8]    ;! load ptr
	mov	x9, x1
	cas	x9, x8, [x0]    ;! atomic ptr
	mov	x0, x9
	ret
	.size	ap_cas, .-ap_cas

	.globl	ap_load
	.type	ap_load, %function
ap_load:                        ;! ptr(ptr)
	ldr	x0, [x0]        ;! atomic load ptr
	ret
	.size	ap_load, .-ap_load

	.section	.note.GNU-stack,"",@progbits
