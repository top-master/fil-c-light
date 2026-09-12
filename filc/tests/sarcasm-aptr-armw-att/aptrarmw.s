	.text
	.globl	alsp_add
	.type	alsp_add, @function
alsp_add:                       ;! ptr(ptr, long)
	# atomic load store ptr WITHOUT lock: atomic load, add, atomic store
	# (each access atomic; the RMW as a whole is not).
	addq	%rsi, (%rdi)      ;! atomic load store ptr
	movq	(%rdi), %rax      ;! load ptr
	ret
	.size	alsp_add, .-alsp_add
	.globl	alsp_lock_add
	.type	alsp_lock_add, @function
alsp_lock_add:                  ;! ptr(ptr, long)
	# WITH lock: a real atomic RMW via the runtime compare-exchange loop.
	lock addq	%rsi, (%rdi)  ;! atomic load store ptr
	movq	(%rdi), %rax      ;! load ptr
	ret
	.size	alsp_lock_add, .-alsp_lock_add
	.globl	alsp_inc
	.type	alsp_inc, @function
alsp_inc:                       ;! ptr(ptr)
	incq	(%rdi)            ;! atomic load store ptr
	movq	(%rdi), %rax      ;! load ptr
	ret
	.size	alsp_inc, .-alsp_inc
	.globl	alsp_lock_inc
	.type	alsp_lock_inc, @function
alsp_lock_inc:                  ;! ptr(ptr)
	lock incq	(%rdi)        ;! atomic load store ptr
	movq	(%rdi), %rax      ;! load ptr
	ret
	.size	alsp_lock_inc, .-alsp_lock_inc
	.globl	alsp_xor
	.type	alsp_xor, @function
alsp_xor:                       ;! long(ptr, long)
	# flags consumer immediately after (no-lock form)
	xorq	%rsi, (%rdi)      ;! atomic load store ptr
	sete	%al
	movzbl	%al, %eax
	ret
	.size	alsp_xor, .-alsp_xor
	.globl	alsp_lock_xor
	.type	alsp_lock_xor, @function
alsp_lock_xor:                  ;! long(ptr, long)
	# flags consumer immediately after (lock form)
	lock xorq	%rsi, (%rdi)  ;! atomic load store ptr
	sete	%al
	movzbl	%al, %eax
	ret
	.size	alsp_lock_xor, .-alsp_lock_xor
	.section	.note.GNU-stack,"",@progbits
