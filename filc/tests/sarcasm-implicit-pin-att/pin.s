	.text
	.globl	cpuid7_all
	.type	cpuid7_all, @function
cpuid7_all:                     ;! void(ptr)
	# Plain helper: rdi -> long[4]; store the cpuid(7,0) outputs (each
	# zero-extended: cpuid writes 32-bit registers).
	movl	$7, %eax
	xorl	%ecx, %ecx
	cpuid
	movq	%rax, (%rdi)
	movq	%rbx, 8(%rdi)
	movq	%rcx, 16(%rdi)
	movq	%rdx, 24(%rdi)
	ret
	.size	cpuid7_all, .-cpuid7_all

	.globl	cpuid_stress
	.type	cpuid_stress, @function
cpuid_stress:                   ;! long(ptr)
	# cpuid under register pressure: six value webs (11,22,33,44,55,66) plus
	# the output-pointer arg stay live across the instruction, which pins
	# rax/rbx/rcx/rdx — regalloc must color every live web AROUND the pinned
	# registers. rdi -> long[4] receives the cpuid(7,0) outputs; returns the
	# sum of the six live webs (= 231). No spills needed: 6+1 live webs fit
	# in the 9 free colors, so the pin moves must all coalesce away.
	movl	$7, %eax
	xorl	%ecx, %ecx
	movq	$11, %r8
	movq	$22, %r9
	movq	$33, %r10
	movq	$44, %r11
	movq	$55, %rsi
	movq	$66, %rbp
	cpuid
	movq	%rax, (%rdi)
	movq	%rbx, 8(%rdi)
	movq	%rcx, 16(%rdi)
	movq	%rdx, 24(%rdi)
	leaq	(%r8,%r9), %rax
	addq	%r10, %rax
	addq	%r11, %rax
	addq	%rsi, %rax
	addq	%rbp, %rax
	ret
	.size	cpuid_stress, .-cpuid_stress

	.globl	cpuid_own
	.type	cpuid_own, @function
cpuid_own:                      ;! long(long)
	# Pin in/out coalescing: the user's OWN eax/ecx webs are exactly cpuid's
	# implicit inputs (pin-in must be move-free) and all four implicit output
	# registers are read immediately after (pin-out must be move-free).
	# rdi = leaf; returns eax+ebx+ecx+edx of cpuid(leaf, 0).
	movl	%edi, %eax
	xorl	%ecx, %ecx
	cpuid
	addq	%rbx, %rax
	addq	%rcx, %rax
	addq	%rdx, %rax
	ret
	.size	cpuid_own, .-cpuid_own

	.globl	cpuid_heavy
	.type	cpuid_heavy, @function
cpuid_heavy:                    ;! long()
	# Heavy pressure: ELEVEN value webs (1..11) are live across the cpuid —
	# more than the 9 colors left after the myth register and the four pinned
	# registers — so regalloc must spill/reload some of them around the
	# instruction. Returns 66 + the four cpuid(7,0) outputs.
	movl	$7, %eax
	xorl	%ecx, %ecx
	movq	$1, %r8
	movq	$2, %r9
	movq	$3, %r10
	movq	$4, %r11
	movq	$5, %rsi
	movq	$6, %rdi
	movq	$7, %rbp
	movq	$8, %r12
	movq	$9, %r13
	movq	$10, %r14
	movq	$11, %r15
	cpuid
	addq	%r8, %rax
	addq	%r9, %rax
	addq	%r10, %rax
	addq	%r11, %rax
	addq	%rsi, %rax
	addq	%rdi, %rax
	addq	%rbp, %rax
	addq	%r12, %rax
	addq	%r13, %rax
	addq	%r14, %rax
	addq	%r15, %rax
	addq	%rbx, %rax
	addq	%rcx, %rax
	addq	%rdx, %rax
	ret
	.size	cpuid_heavy, .-cpuid_heavy
	.section	.note.GNU-stack,"",@progbits
