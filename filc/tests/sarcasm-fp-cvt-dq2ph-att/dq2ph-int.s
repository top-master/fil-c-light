	.intel_syntax noprefix
	.text
	.globl	dq2ph_int
	.type	dq2ph_int, @function
dq2ph_int:                      ;! void(ptr, ptr)
	# vcvtdq2ph ymm0, ZMMWORD PTR [rdi]: the Intel PTR size drives an
	# exact 64-byte m512 source width with no x/y/z source suffix (no
	# contradiction with the bare mnemonic). Called only when CPUID
	# reports AVX512-FP16 (see dq2ph.s). rdi -> int32[16]; rsi ->
	# uint16[16] out.
	vcvtdq2ph	ymm0, ZMMWORD PTR [rdi]
	vmovdqu	YMMWORD PTR [rsi], ymm0
	ret
	.size	dq2ph_int, .-dq2ph_int
	.globl	udq2ph_int
	.type	udq2ph_int, @function
udq2ph_int:                     ;! void(ptr, ptr)
	vcvtudq2ph	ymm1, ZMMWORD PTR [rdi]
	vmovdqu	YMMWORD PTR [rsi], ymm1
	ret
	.size	udq2ph_int, .-udq2ph_int
	.section	.note.GNU-stack,"",@progbits
