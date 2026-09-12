	.intel_syntax noprefix
	.text
	.globl	cpuid1_ecx_int
	.type	cpuid1_ecx_int, @function
cpuid1_ecx_int:                 ;! long()
	mov	eax, 1
	xor	ecx, ecx
	cpuid
	mov	eax, ecx
	ret
	.size	cpuid1_ecx_int, .-cpuid1_ecx_int

	.globl	mon_arm_int
	.type	mon_arm_int, @function
mon_arm_int:                    ;! void(ptr)
	mov	rax, rdi
	xor	ecx, ecx
	xor	edx, edx
	monitor
	ret
	.size	mon_arm_int, .-mon_arm_int

	.globl	mwait0_int
	.type	mwait0_int, @function
mwait0_int:                     ;! void()
	xor	eax, eax
	xor	ecx, ecx
	mwait
	ret
	.size	mwait0_int, .-mwait0_int
	.section	.note.GNU-stack,"",@progbits
