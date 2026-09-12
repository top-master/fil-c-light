	.text
	.globl	cas16_test
	.type	cas16_test, @function
cas16_test:                     ;! void(ptr, ptr)
	# rdi -> long args[16]: [0]=expected lo, [1]=expected hi, [2]=desired lo,
	# [3]=desired hi; out: [4]=old lo, [5]=old hi,
	# [6]=flag + [7]+[8]+[9] + desired-lo (rbx, preserved across the CAS).
	# rsi -> 16-byte aligned 16-byte buffer.
	# The implicit rdx:rax (expected, mismatch writeback) and rcx:rbx (desired)
	# pairs are pinned through emitPinned; the [7]/[8]/[9] webs stay live
	# ACROSS the pin (register pressure around the fixed rax/rdx/rbx/rcx).
	movq	(%rdi), %rax
	movq	8(%rdi), %rdx
	movq	16(%rdi), %rbx
	movq	24(%rdi), %rcx
	movq	56(%rdi), %r8
	movq	64(%rdi), %r9
	movq	72(%rdi), %r10
	lock cmpxchg16b	(%rsi)
	# sete must IMMEDIATELY follow the CAS: sarcasm's injected bounds checks
	# (for the stores below) clobber EFLAGS (a documented sarcasm property) —
	# only flag-neutral pin-out moves sit between them here.
	sete	%cl
	movq	%rax, 32(%rdi)
	movq	%rdx, 40(%rdi)
	movzbl	%cl, %ecx
	addq	%r8, %rcx
	addq	%r9, %rcx
	addq	%r10, %rcx
	# rbx still holds the desired-lo value here (hardware does not write it):
	# its web is BOTH the implicit pinned source and live ACROSS the CAS.
	addq	%rbx, %rcx
	movq	%rcx, 48(%rdi)
	ret
	.size	cas16_test, .-cas16_test

	.globl	cas16_ul_test
	.type	cas16_ul_test, @function
cas16_ul_test:                  ;! void(ptr, ptr)
	# same, without the lock prefix (legal too — the access check is identical)
	movq	(%rdi), %rax
	movq	8(%rdi), %rdx
	movq	16(%rdi), %rbx
	movq	24(%rdi), %rcx
	movq	56(%rdi), %r8
	movq	64(%rdi), %r9
	movq	72(%rdi), %r10
	cmpxchg16b	(%rsi)
	sete	%cl
	movq	%rax, 32(%rdi)
	movq	%rdx, 40(%rdi)
	movzbl	%cl, %ecx
	addq	%r8, %rcx
	addq	%r9, %rcx
	addq	%r10, %rcx
	addq	%rbx, %rcx
	movq	%rcx, 48(%rdi)
	ret
	.size	cas16_ul_test, .-cas16_ul_test
	.section	.note.GNU-stack,"",@progbits
