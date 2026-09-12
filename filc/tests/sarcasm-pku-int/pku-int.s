	.intel_syntax noprefix
	.text
	.globl	cpuid_max_leaf_int
	.type	cpuid_max_leaf_int, @function
cpuid_max_leaf_int:             ;! long()
	xor	eax, eax
	xor	ecx, ecx
	cpuid
	ret
	.size	cpuid_max_leaf_int, .-cpuid_max_leaf_int

	.globl	cpuid7_ecx_int
	.type	cpuid7_ecx_int, @function
cpuid7_ecx_int:                 ;! long()
	mov	eax, 7
	xor	ecx, ecx
	cpuid
	mov	eax, ecx
	ret
	.size	cpuid7_ecx_int, .-cpuid7_ecx_int

	.globl	pkru_read_int
	.type	pkru_read_int, @function
pkru_read_int:                  ;! long()
	xor	ecx, ecx
	rdpkru
	ret
	.size	pkru_read_int, .-pkru_read_int

	.globl	pkru_write_int
	.type	pkru_write_int, @function
pkru_write_int:                 ;! void(long)
	mov	eax, edi
	xor	ecx, ecx
	xor	edx, edx
	wrpkru
	ret
	.size	pkru_write_int, .-pkru_write_int
	.section	.note.GNU-stack,"",@progbits
