	.text
	.globl	cas8_test
	.type	cas8_test, @function
cas8_test:                      ;! void(ptr, ptr)
	# rdi -> struct { int expLo, expHi, desLo, desHi, oldLo, oldHi; long pad;
	#                 long live1, live2, flag; }   (ints at 0..20, live1=32,
	#                 live2=40, flag=48)
	# rsi -> 8-byte buffer. The implicit edx:eax (expected, mismatch
	# writeback) and ecx:ebx (desired) pairs are pinned through emitPinned;
	# the live1/live2 webs stay live ACROSS the pin (register pressure around
	# the fixed rax/rdx/rbx/rcx).
	movl	(%rdi), %eax
	movl	4(%rdi), %edx
	movl	8(%rdi), %ebx
	movl	12(%rdi), %ecx
	movq	32(%rdi), %r8
	movq	40(%rdi), %r9
	lock cmpxchg8b	(%rsi)
	# sete must IMMEDIATELY follow the CAS: sarcasm's injected bounds checks
	# (for the stores below) clobber EFLAGS (a documented sarcasm property).
	sete	%cl
	movl	%eax, 16(%rdi)
	movl	%edx, 20(%rdi)
	movzbl	%cl, %ecx
	addq	%r8, %rcx
	addq	%r9, %rcx
	movq	%rcx, 48(%rdi)
	ret
	.size	cas8_test, .-cas8_test

	.globl	cas8_ul_test
	.type	cas8_ul_test, @function
cas8_ul_test:                   ;! void(ptr, ptr)
	# same, without the lock prefix (legal too — the access check is identical)
	movl	(%rdi), %eax
	movl	4(%rdi), %edx
	movl	8(%rdi), %ebx
	movl	12(%rdi), %ecx
	movq	32(%rdi), %r8
	movq	40(%rdi), %r9
	cmpxchg8b	(%rsi)
	sete	%cl
	movl	%eax, 16(%rdi)
	movl	%edx, 20(%rdi)
	movzbl	%cl, %ecx
	addq	%r8, %rcx
	addq	%r9, %rcx
	movq	%rcx, 48(%rdi)
	ret
	.size	cas8_ul_test, .-cas8_ul_test
	.section	.note.GNU-stack,"",@progbits
