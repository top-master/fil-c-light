	.text
	.globl	ap_lock_add8
	.type	ap_lock_add8, @function
ap_lock_add8:                   ;! void(ptr)
	# one locked atomic pointer RMW (runtime CAS loop): slot += 8, with the
	# capability riding through every hop.
	lock addq	$8, (%rdi)    ;! atomic load store ptr
	ret
	.size	ap_lock_add8, .-ap_lock_add8
	.globl	ap_lock_dec8
	.type	ap_lock_dec8, @function
ap_lock_dec8:                   ;! void(ptr)
	lock subq	$8, (%rdi)    ;! atomic load store ptr
	ret
	.size	ap_lock_dec8, .-ap_lock_dec8
	.globl	ap_load
	.type	ap_load, @function
ap_load:                        ;! ptr(ptr)
	movq	(%rdi), %rax      ;! atomic load ptr
	ret
	.size	ap_load, .-ap_load
	.section	.note.GNU-stack,"",@progbits
