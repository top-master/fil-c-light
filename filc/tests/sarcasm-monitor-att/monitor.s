	.text
	.globl	cpuid1_ecx
	.type	cpuid1_ecx, @function
cpuid1_ecx:                     ;! long()
	# cpuid leaf 1: return ecx (MONITOR/MWAIT feature = bit 3).
	movl	$1, %eax
	xorl	%ecx, %ecx
	cpuid
	movl	%ecx, %eax
	ret
	.size	cpuid1_ecx, .-cpuid1_ecx

	.globl	mon_arm
	.type	mon_arm, @function
mon_arm:                        ;! void(ptr)
	# monitor: implicit uses rax (64-bit address to arm on), ecx (extensions,
	# must be 0), edx (hints, 0). No defs and NO memory operand — MONITOR does
	# not access memory, so there is nothing to bounds-check.
	movq	%rdi, %rax
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	monitor
	ret
	.size	mon_arm, .-mon_arm

	.globl	mwait0
	.type	mwait0, @function
mwait0:                         ;! void()
	# mwait: implicit uses eax (hints) and ecx (extensions). No defs.
	xorl	%eax, %eax
	xorl	%ecx, %ecx
	mwait
	ret
	.size	mwait0, .-mwait0
	.section	.note.GNU-stack,"",@progbits
