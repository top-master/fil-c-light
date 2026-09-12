	.text
	.globl	fp_ap_store
	.type	fp_ap_store, @function
fp_ap_store:                    ;! long(ptr, long)
	# xmm0 (a double converted from rsi) is live ACROSS the runtime atomic
	# pointer store call (which can allocate => can clobber caller-saved xmm):
	# sarcasm's fpSave/fpRestore must preserve it.
	cvtsi2sdq	%rsi, %xmm0
	movq	8(%rdi), %rcx     ;! load ptr
	movq	%rcx, (%rdi)      ;! atomic store ptr
	cvttsd2siq	%xmm0, %rax
	ret
	.size	fp_ap_store, .-fp_ap_store
	.globl	fp_ap_cas
	.type	fp_ap_cas, @function
fp_ap_cas:                      ;! long(ptr, ptr)
	# same across the pointer compare-exchange runtime call
	movq	16(%rdi), %rdx
	cvtsi2sdq	%rdx, %xmm0
	movq	8(%rdi), %rcx     ;! load ptr
	movq	%rsi, %rax
	cmpxchgq	%rcx, (%rdi)  ;! atomic ptr
	cvttsd2siq	%xmm0, %rax
	ret
	.size	fp_ap_cas, .-fp_ap_cas
	.globl	fp_alsp_lock_add
	.type	fp_alsp_lock_add, @function
fp_alsp_lock_add:               ;! long(ptr, long)
	# same across the locked atomic-RMW compare-exchange loop's calls
	cvtsi2sdq	%rsi, %xmm0
	lock addq	%rsi, (%rdi)  ;! atomic load store ptr
	cvttsd2siq	%xmm0, %rax
	ret
	.size	fp_alsp_lock_add, .-fp_alsp_lock_add
	.section	.note.GNU-stack,"",@progbits
