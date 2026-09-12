	.text
	.globl	merge_load
	.type	merge_load, @function
merge_load:                     ;! long(ptr, long)
	# zmm0 = all-7; masked load (%rdi) with {%k1} (merge); return the lane sum.
	movq	$7, %rax
	vpbroadcastq	%rax, %zmm0
	kmovw	%esi, %k1
	vmovdqu64	(%rdi), %zmm0{%k1}
	vextracti64x4	$1, %zmm0, %ymm1
	vpaddq	%ymm1, %ymm0, %ymm0
	vextracti64x2	$1, %ymm0, %xmm1
	vpaddq	%xmm1, %xmm0, %xmm0
	vpextrq	$1, %xmm0, %rdx
	vmovq	%xmm0, %rax
	addq	%rdx, %rax
	ret
	.size	merge_load, .-merge_load

	.globl	sparse_store
	.type	sparse_store, @function
sparse_store:                   ;! void(ptr, long)
	# store lane value 42 to the {%k1} lanes of (%rdi)
	movq	$42, %rax
	vpbroadcastq	%rax, %zmm0
	kmovw	%esi, %k1
	vmovdqu64	%zmm0, (%rdi){%k1}
	ret
	.size	sparse_store, .-sparse_store

	.globl	byte_sum
	.type	byte_sum, @function
byte_sum:                       ;! long(ptr, long)
	# ymm vmovdqu8 {z}-masked load of the low 32 bytes of (%rdi); sum them.
	kmovd	%esi, %k1
	vpxorq	%zmm0, %zmm0, %zmm0
	vmovdqu8	(%rdi), %ymm0{%k1}{z}
	vpxorq	%zmm1, %zmm1, %zmm1
	vpsadbw	%ymm1, %ymm0, %ymm0
	# sum the 4 qword partial sums
	vextracti64x2	$1, %ymm0, %xmm1
	vpaddq	%xmm1, %xmm0, %xmm0
	vpextrq	$1, %xmm0, %rdx
	vmovq	%xmm0, %rax
	addq	%rdx, %rax
	ret
	.size	byte_sum, .-byte_sum

	.globl	ups_store
	.type	ups_store, @function
ups_store:                      ;! void(ptr, long)
	# store 9.25f to the {%k1} lanes of the 4-float vector at (%rdi)
	kmovw	%esi, %k1
	movl	$0x41140000, %eax
	vmovd	%eax, %xmm0
	vbroadcastss	%xmm0, %xmm0
	vmovups	%xmm0, (%rdi){%k1}
	ret
	.size	ups_store, .-ups_store

	.globl	zero_mask
	.type	zero_mask, @function
zero_mask:                      ;! long(ptr, long)
	# zero-mask load and store: no memory touched.
	kmovw	%esi, %k1
	vmovdqu64	(%rdi), %zmm0{%k1}{z}
	vmovdqu64	%zmm0, (%rdi){%k1}
	movq	$5, %rax
	ret
	.size	zero_mask, .-zero_mask
	.section	.note.GNU-stack,"",@progbits
