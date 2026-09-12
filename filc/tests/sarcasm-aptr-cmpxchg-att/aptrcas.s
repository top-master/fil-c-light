	.text
	.globl	ap_cas
	.type	ap_cas, @function
ap_cas:                         ;! ptr(ptr, ptr)
	# rdi -> pair: [rdi] = the CAS slot, [rdi+8] = the new value (a pointer).
	# rsi = expected. Returns the old value (with its capability).
	movq	8(%rdi), %rcx     ;! load ptr
	movq	%rsi, %rax
	cmpxchgq	%rcx, (%rdi)  ;! atomic ptr
	ret
	.size	ap_cas, .-ap_cas
	.globl	ap_cas_lock
	.type	ap_cas_lock, @function
ap_cas_lock:                    ;! ptr(ptr, ptr)
	# same, with the lock prefix (still goes through the runtime call)
	movq	8(%rdi), %rcx     ;! load ptr
	movq	%rsi, %rax
	lock cmpxchgq	%rcx, (%rdi)  ;! atomic ptr
	ret
	.size	ap_cas_lock, .-ap_cas_lock
	.globl	ap_cas_zf
	.type	ap_cas_zf, @function
ap_cas_zf:                      ;! long(ptr, ptr)
	# returns ZF of the exchange (1 iff it happened): a flag consumer
	# immediately after the annotated cmpxchg must behave natively.
	movq	8(%rdi), %rcx     ;! load ptr
	movq	%rsi, %rax
	cmpxchgq	%rcx, (%rdi)  ;! atomic ptr
	sete	%al
	movzbl	%al, %eax
	ret
	.size	ap_cas_zf, .-ap_cas_zf
	.globl	ap_add
	.type	ap_add, @function
ap_add:                         ;! ptr(ptr, long)
	# the compare-exchange retry idiom: atomically add rsi to the pointer
	# slot, return the old pointer (with capability).
	movq	(%rdi), %rax      ;! atomic load ptr
.L1:
	movq	%rax, %rcx
	addq	%rsi, %rcx
	cmpxchgq	%rcx, (%rdi)  ;! atomic ptr
	jne	.L1
	ret
	.size	ap_add, .-ap_add
	.section	.note.GNU-stack,"",@progbits
