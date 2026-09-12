	.text
	.globl	below_load
	.type	below_load, @function
below_load:                     ;! long(ptr, long)
	# {z}-masked vmovdqu64 load at (%rdi) with {%k1}; sum lanes 2,3.
	kmovw	%esi, %k1
	vmovdqu64	(%rdi), %zmm0{%k1}{z}
	vextracti64x2	$1, %zmm0, %xmm1
	vmovq	%xmm1, %rax
	vpextrq	$1, %xmm1, %rdx
	addq	%rdx, %rax
	ret
	.size	below_load, .-below_load

	.globl	above_load
	.type	above_load, @function
above_load:                     ;! long(ptr, long)
	# {z}-masked vmovdqu64 load at (%rdi) with {%k1}; return lane 0.
	kmovw	%esi, %k1
	vmovdqu64	(%rdi), %zmm0{%k1}{z}
	vmovq	%xmm0, %rax
	ret
	.size	above_load, .-above_load

	.globl	below_store
	.type	below_store, @function
below_store:                    ;! long(ptr, long)
	# masked vmovdqu64 store of 55s at (%rdi) with {%k1}
	kmovw	%esi, %k1
	movq	$55, %rax
	vpbroadcastq	%rax, %zmm0
	vmovdqu64	%zmm0, (%rdi){%k1}
	movq	$3, %rax
	ret
	.size	below_store, .-below_store

	.globl	above_store
	.type	above_store, @function
above_store:                    ;! long(ptr, long)
	# masked vmovdqu64 store of 77s at (%rdi) with {%k1}
	kmovw	%esi, %k1
	movq	$77, %rax
	vpbroadcastq	%rax, %zmm0
	vmovdqu64	%zmm0, (%rdi){%k1}
	movq	$4, %rax
	ret
	.size	above_store, .-above_store

	.globl	zero_below
	.type	zero_below, @function
zero_below:                     ;! long(ptr, long)
	# mask==0 load: touches no memory even though (%rdi) is out of bounds
	kmovw	%esi, %k1
	vmovdqu64	(%rdi), %zmm0{%k1}{z}
	movq	$6, %rax
	ret
	.size	zero_below, .-zero_below

	.globl	zero_above
	.type	zero_above, @function
zero_above:                     ;! long(ptr, long)
	# mask==0 store: touches no memory even though (%rdi) is out of bounds
	kmovw	%esi, %k1
	vmovdqu64	%zmm0, (%rdi){%k1}
	movq	$8, %rax
	ret
	.size	zero_above, .-zero_above
	.section	.note.GNU-stack,"",@progbits
