	.text
	.globl	cpuid_vendor
	.type	cpuid_vendor, @function
cpuid_vendor:                   ;! long(ptr)
	# cpuid leaf 0: returns the max basic leaf (eax) and stores the 12-byte
	# vendor string (ebx, edx, ecx order) into the 16-byte object at rdi.
	# Exercises the implicit use of eax/ecx and the implicit defs of
	# eax/ebx/ecx/edx pinned around the instruction.
	xorl	%eax, %eax
	xorl	%ecx, %ecx
	cpuid
	movl	%ebx, (%rdi)
	movl	%edx, 4(%rdi)
	movl	%ecx, 8(%rdi)
	movl	$0, 12(%rdi)
	ret
	.size	cpuid_vendor, .-cpuid_vendor

	.globl	rdtsc_now
	.type	rdtsc_now, @function
rdtsc_now:                      ;! long()
	# rdtsc: implicit defs eax (low) and edx (high); combine into a 64-bit TSC.
	rdtsc
	shlq	$32, %rdx
	orq	%rdx, %rax
	ret
	.size	rdtsc_now, .-rdtsc_now

	.globl	rdtscp_now
	.type	rdtscp_now, @function
rdtscp_now:                     ;! long(ptr)
	# rdtscp: implicit defs eax/edx (TSC) and ecx (TSC_AUX); the aux value is
	# stored to the unsigned at rdi, the 64-bit TSC returned.
	rdtscp
	movl	%ecx, (%rdi)
	shlq	$32, %rdx
	orq	%rdx, %rax
	ret
	.size	rdtscp_now, .-rdtscp_now

	.globl	xgetbv0
	.type	xgetbv0, @function
xgetbv0:                        ;! long()
	# xgetbv with ecx=0 (XCR0): implicit use of ecx, implicit defs eax/edx.
	xorl	%ecx, %ecx
	xgetbv
	ret
	.size	xgetbv0, .-xgetbv0
	.section	.note.GNU-stack,"",@progbits
