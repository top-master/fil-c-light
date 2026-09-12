	.text
	.globl	cpuid_max_leaf
	.type	cpuid_max_leaf, @function
cpuid_max_leaf:                 ;! long()
	# cpuid leaf 0: return the max basic leaf (eax).
	xorl	%eax, %eax
	xorl	%ecx, %ecx
	cpuid
	ret
	.size	cpuid_max_leaf, .-cpuid_max_leaf

	.globl	cpuid7_ecx
	.type	cpuid7_ecx, @function
cpuid7_ecx:                     ;! long()
	# cpuid leaf 7 sub-leaf 0: return ecx (PKU = bit 3, OSPKE = bit 4).
	movl	$7, %eax
	xorl	%ecx, %ecx
	cpuid
	movl	%ecx, %eax
	ret
	.size	cpuid7_ecx, .-cpuid7_ecx

	.globl	pkru_read
	.type	pkru_read, @function
pkru_read:                      ;! long()
	# rdpkru: implicit use of ecx (must be 0), implicit defs eax (PKRU) and
	# edx (zeroed).
	xorl	%ecx, %ecx
	rdpkru
	ret
	.size	pkru_read, .-pkru_read

	.globl	pkru_write
	.type	pkru_write, @function
pkru_write:                     ;! void(long)
	# wrpkru: implicit uses eax (PKRU value), ecx (=0), edx (=0). No defs.
	movl	%edi, %eax
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	wrpkru
	ret
	.size	pkru_write, .-pkru_write
	.section	.note.GNU-stack,"",@progbits
