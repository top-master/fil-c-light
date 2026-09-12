	.text
	.globl	maskload_ps
	.type	maskload_ps, @function
maskload_ps:                    ;! long(ptr, long)
	# build the ymm mask vector from k's bits (sign bit per dword lane):
	# ymm4 = {1,2,4,...,128}, ymm5 = k broadcast; lane i of (ymm5 & ymm4) is
	# nonzero iff bit i of k is set; the >0 compare spreads it to the sign.
	movq	$0, %rax
	vmovd	%eax, %xmm4
	movq	$1, %rax
	vpinsrd	$1, %eax, %xmm4, %xmm4
	movq	$2, %rax
	vpinsrd	$2, %eax, %xmm4, %xmm4
	movq	$3, %rax
	vpinsrd	$3, %eax, %xmm4, %xmm4
	movq	$4, %rax
	vmovd	%eax, %xmm5
	movq	$5, %rax
	vpinsrd	$1, %eax, %xmm5, %xmm5
	movq	$6, %rax
	vpinsrd	$2, %eax, %xmm5, %xmm5
	movq	$7, %rax
	vpinsrd	$3, %eax, %xmm5, %xmm5
	vinserti128	$1, %xmm5, %ymm4, %ymm4   # ymm4 = {0,1,2,3,4,5,6,7}
	movq	$1, %rax
	vpbroadcastd	%eax, %ymm5
	vpsllvd	%ymm4, %ymm5, %ymm4            # ymm4 = {1,2,4,...,128}
	vpbroadcastd	%esi, %ymm5
	vpand	%ymm4, %ymm5, %ymm5            # bit i of k in lane i (or 0)
	vpxor	%ymm6, %ymm6, %ymm6
	vpcmpgtd	%ymm6, %ymm5, %ymm5        # 0xFFFFFFFF where the bit is set
	vmaskmovps	(%rdi), %ymm5, %ymm0
	# sum the 8 loaded floats (truncate each to int)
	vcvttps2dq	%ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpaddd	%xmm1, %xmm0, %xmm0
	vpshufd	$0x4E, %xmm0, %xmm1
	vpaddd	%xmm1, %xmm0, %xmm0
	vpshufd	$0xB1, %xmm0, %xmm1
	vpaddd	%xmm1, %xmm0, %xmm0
	vmovd	%xmm0, %eax
	ret
	.size	maskload_ps, .-maskload_ps

	.globl	maskstore_q
	.type	maskstore_q, @function
maskstore_q:                    ;! long(ptr, long)
	# build the ymm mask vector from k's 4 low bits (sign bit per qword lane):
	# ymm4 = qwords {1,2,4,8}; lane i of (k & ymm4) > 0 iff bit i of k is set.
	movq	$1, %rax
	vmovq	%rax, %xmm4
	movq	$2, %rax
	vpinsrq	$1, %rax, %xmm4, %xmm4
	movq	$4, %rax
	vmovq	%rax, %xmm5
	movq	$8, %rax
	vpinsrq	$1, %rax, %xmm5, %xmm5
	vinserti128	$1, %xmm5, %ymm4, %ymm4   # ymm4 = {1,2,4,8} (qwords)
	vpbroadcastq	%rsi, %ymm5
	vpand	%ymm4, %ymm5, %ymm5
	vpxor	%ymm6, %ymm6, %ymm6
	vpcmpgtq	%ymm6, %ymm5, %ymm5         # all-ones where the bit is set
	movq	$88, %rax
	vpbroadcastq	%rax, %ymm0
	vpmaskmovq	%ymm0, %ymm5, (%rdi)
	movq	$12, %rax
	ret
	.size	maskstore_q, .-maskstore_q

	.globl	maskload_zero
	.type	maskload_zero, @function
maskload_zero:                  ;! long(ptr, long)
	# zero mask (all sign bits clear): the load touches no memory.
	vpxor	%ymm5, %ymm5, %ymm5
	vmaskmovps	(%rdi), %ymm5, %ymm0
	movq	$14, %rax
	ret
	.size	maskload_zero, .-maskload_zero
	.section	.note.GNU-stack,"",@progbits
