	.text
	.globl	al_load
	.type	al_load, @function
al_load:                        ;! long(ptr, long)
	# vmovdqa32 {z}-masked load at (%rdi) with {%k1}; sum the loaded dwords.
	kmovw	%esi, %k1
	vmovdqa32	(%rdi), %zmm0{%k1}{z}
	vextracti64x4	$1, %zmm0, %ymm1
	vpaddd	%ymm1, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpaddd	%xmm1, %xmm0, %xmm0
	vpshufd	$0x4E, %xmm0, %xmm1
	vpaddd	%xmm1, %xmm0, %xmm0
	vpshufd	$0xB1, %xmm0, %xmm1
	vpaddd	%xmm1, %xmm0, %xmm0
	vmovd	%xmm0, %eax
	ret
	.size	al_load, .-al_load

	.globl	al_store
	.type	al_store, @function
al_store:                       ;! long(ptr, long)
	# vmovaps masked store of 8.5f lanes at (%rdi) with {%k1}
	kmovw	%esi, %k1
	movl	$0x41080000, %eax
	vmovd	%eax, %xmm0
	vbroadcastss	%xmm0, %xmm0
	vmovaps	%xmm0, (%rdi){%k1}
	movq	$7, %rax
	ret
	.size	al_store, .-al_store
	.section	.note.GNU-stack,"",@progbits
