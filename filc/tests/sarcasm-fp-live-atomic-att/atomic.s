	.text
	.globl	fp_atomic_mix
	.type	fp_atomic_mix, @function
fp_atomic_mix:                  ;! long(ptr, ptr)
	# Mixed-width xmm state live across the injected atomic-pointer runtime
	# calls: xmm0 @8 (a double, from movq) and xmm2 @16 (a movdqu pair) must
	# both survive filc_store_ptr_atomic_outline; xmm1 is written between
	# the load and the store but DEAD across the store call (overwritten
	# after, never read) — no save for it. (-S verified: movsd for xmm0 +
	# movdqu for xmm2 only, around the store call.)
	movabsq	$4635400285215260672, %rax
	movq	%rax, %xmm0
	movdqu	(%rsi), %xmm2
	movq	8(%rdi), %rcx     ;! load ptr
	addsd	%xmm0, %xmm1
	movq	%rcx, (%rdi)      ;! atomic store ptr
	pxor	%xmm1, %xmm1
	cvttsd2siq	%xmm0, %rax
	movdqu	%xmm2, (%rsi)
	ret
	.size	fp_atomic_mix, .-fp_atomic_mix
	.section	.note.GNU-stack,"",@progbits
