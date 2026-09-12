	.text
	.globl	bcast_zmm
	.type	bcast_zmm, @function
bcast_zmm:                      ;! long(ptr, ptr)
	# Regression test for the AVX512 decorator-drop soundness bug in stack-slot
	# materialization: the {1to16} embedded broadcast reads ONE 4-byte element
	# from the stack slot at -64(%rbp) (sized 4 bytes by the decorated access
	# width) and broadcasts it to all 16 lanes. If the decorator were dropped
	# when the slot is materialized, this would become a full 64-byte read of
	# garbage lanes.
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	movl	$1069547520, -64(%rbp)  # 1.5f
	vmovdqu64	(%rsi), %zmm1
	vaddps	-64(%rbp){1to16}, %zmm1, %zmm2
	vmovdqu64	%zmm2, (%rdi)
	xorl	%eax, %eax
	leave
	ret
	.size	bcast_zmm, .-bcast_zmm
	.globl	bcast_xmm
	.type	bcast_xmm, @function
bcast_xmm:                      ;! long(ptr, ptr)
	# {1to4} variant: one 4-byte stack element broadcast to 4 xmm lanes; a
	# dropped decorator would make this a 16-byte read of garbage lanes.
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
	movl	$1075838976, -64(%rbp)  # 2.5f
	vmovups	(%rsi), %xmm1
	vaddps	-64(%rbp){1to4}, %xmm1, %xmm2
	vmovups	%xmm2, (%rdi)
	xorl	%eax, %eax
	leave
	ret
	.size	bcast_xmm, .-bcast_xmm
	.section	.note.GNU-stack,"",@progbits
