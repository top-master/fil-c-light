	.intel_syntax noprefix
	.text
	.globl	merge_load
	.type	merge_load, @function
merge_load:                     ;! long(ptr, long)
	# zmm0 = all-7; masked load [rdi] with {k1} (merge); return the lane sum.
	mov	rax, 7
	vpbroadcastq	zmm0, rax
	kmovw	k1, esi
	vmovdqu64	zmm0{k1}, [rdi]
	vextracti64x4	ymm1, zmm0, 1
	vpaddq	ymm0, ymm0, ymm1
	vextracti64x2	xmm1, ymm0, 1
	vpaddq	xmm0, xmm0, xmm1
	vpextrq	rdx, xmm0, 1
	vmovq	rax, xmm0
	add	rax, rdx
	ret
	.size	merge_load, .-merge_load

	.globl	sparse_store
	.type	sparse_store, @function
sparse_store:                   ;! void(ptr, long)
	mov	rax, 42
	vpbroadcastq	zmm0, rax
	kmovw	k1, esi
	vmovdqu64	[rdi]{k1}, zmm0
	ret
	.size	sparse_store, .-sparse_store

	.globl	byte_sum
	.type	byte_sum, @function
byte_sum:                       ;! long(ptr, long)
	kmovd	k1, esi
	vpxorq	zmm0, zmm0, zmm0
	vmovdqu8	ymm0{k1}{z}, [rdi]
	vpxorq	zmm1, zmm1, zmm1
	vpsadbw	ymm0, ymm0, ymm1
	vextracti64x2	xmm1, ymm0, 1
	vpaddq	xmm0, xmm0, xmm1
	vpextrq	rdx, xmm0, 1
	vmovq	rax, xmm0
	add	rax, rdx
	ret
	.size	byte_sum, .-byte_sum

	.globl	ups_store
	.type	ups_store, @function
ups_store:                      ;! void(ptr, long)
	kmovw	k1, esi
	mov	eax, 0x41140000
	vmovd	xmm0, eax
	vbroadcastss	xmm0, xmm0
	vmovups	[rdi]{k1}, xmm0
	ret
	.size	ups_store, .-ups_store

	.globl	zero_mask
	.type	zero_mask, @function
zero_mask:                      ;! long(ptr, long)
	kmovw	k1, esi
	vmovdqu64	zmm0{k1}{z}, [rdi]
	vmovdqu64	[rdi]{k1}, zmm0
	mov	rax, 5
	ret
	.size	zero_mask, .-zero_mask
	.section	.note.GNU-stack,"",@progbits
