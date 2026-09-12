	.intel_syntax noprefix
	.text
	.globl	cvtmem_ss
	.type	cvtmem_ss, @function
cvtmem_ss:                      ;! void(ptr, ptr)
	# m64 integer source (QWORD PTR size-driven, renders as vcvtusi2ssq):
	# 8-byte checked load ending exactly at the end of a 16-byte allocation.
	vcvtusi2ss	xmm1, xmm0, QWORD PTR [rdi]
	movss	DWORD PTR [rsi], xmm1
	ret
	.size	cvtmem_ss, .-cvtmem_ss
	.globl	cvtmem_sd
	.type	cvtmem_sd, @function
cvtmem_sd:                      ;! void(ptr, ptr)
	vcvtusi2sd	xmm2, xmm1, QWORD PTR [rdi]
	movsd	QWORD PTR [rsi], xmm2
	ret
	.size	cvtmem_sd, .-cvtmem_sd
	.section	.note.GNU-stack,"",@progbits
