	.text
	.globl	trunc_qb
	.type	trunc_qb, @function
trunc_qb:                       ;! long(ptr, long)
	# zmm0 = qword lanes {0x11,0x22,...,0x88}; vpmovqb store to (%rdi) with {%k1}
	kmovw	%esi, %k1
	movq	$1, %rax
	vmovq	%rax, %xmm1
	movq	$2, %rax
	vpinsrq	$1, %rax, %xmm1, %xmm1
	movq	$3, %rax
	vmovq	%rax, %xmm2
	movq	$4, %rax
	vpinsrq	$1, %rax, %xmm2, %xmm2
	vinserti128	$1, %xmm2, %ymm1, %ymm1
	movq	$5, %rax
	vmovq	%rax, %xmm3
	movq	$6, %rax
	vpinsrq	$1, %rax, %xmm3, %xmm3
	movq	$7, %rax
	vmovq	%rax, %xmm4
	movq	$8, %rax
	vpinsrq	$1, %rax, %xmm4, %xmm4
	vinserti128	$1, %xmm4, %ymm3, %ymm3
	vinserti64x4	$1, %ymm3, %zmm1, %zmm1   # zmm1 = {1,2,3,4,5,6,7,8}
	movq	$0x11, %rax
	vpbroadcastq	%rax, %zmm0
	vpmullq	%zmm1, %zmm0, %zmm0              # lanes {0x11,...,0x88}
	vpmovqb	%zmm0, (%rdi){%k1}
	movq	$5, %rax
	ret
	.size	trunc_qb, .-trunc_qb

	.globl	trunc_dw
	.type	trunc_dw, @function
trunc_dw:                       ;! long(ptr, long)
	# zmm0 = dwords 0x77; vpmovdw store to (%rdi) with {%k1}
	kmovw	%esi, %k1
	movq	$0x77, %rax
	vpbroadcastd	%eax, %zmm0
	vpmovdw	%zmm0, (%rdi){%k1}
	movq	$6, %rax
	ret
	.size	trunc_dw, .-trunc_dw

	.globl	trunc_qb_below
	.type	trunc_qb_below, @function
trunc_qb_below:                 ;! long(ptr, long)
	# zmm0 = 0x42 bytes; vpmovqb store to (%rdi) with {%k1}
	kmovw	%esi, %k1
	movq	$0x42, %rax
	vpbroadcastq	%rax, %zmm0
	vpmovqb	%zmm0, (%rdi){%k1}
	movq	$7, %rax
	ret
	.size	trunc_qb_below, .-trunc_qb_below
	.section	.note.GNU-stack,"",@progbits
