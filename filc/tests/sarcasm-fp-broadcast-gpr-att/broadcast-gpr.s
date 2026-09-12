	.text
	.globl	bcast_d_gpr
	.type	bcast_d_gpr, @function
bcast_d_gpr:                    ;! long(long, long, ptr)
	# THE GPR-source broadcast miscompile regression: vpbroadcastd with a GPR
	# source READS that GPR. The source here is a value computed in-function
	# (%eax = a*b); if the GPR use is not modeled, regalloc/lift can broadcast
	# a stale register instead (the driver passes 6 and 7: all lanes must be
	# 42, not 6 or 7). (EVEX r32-source form: AVX512.)
	movl	%edi, %eax
	imull	%esi, %eax
	vpbroadcastd	%eax, %xmm0
	vmovdqu	%xmm0, (%rdx)
	xorl	%eax, %eax
	ret
	.size	bcast_d_gpr, .-bcast_d_gpr
	.globl	bcast_b_gpr
	.type	bcast_b_gpr, @function
bcast_b_gpr:                    ;! long(long, long, ptr)
	# Same regression, byte form: source is a+b computed in-function.
	movl	%edi, %eax
	addl	%esi, %eax
	vpbroadcastb	%eax, %xmm0
	vmovdqu	%xmm0, (%rdx)
	xorl	%eax, %eax
	ret
	.size	bcast_b_gpr, .-bcast_b_gpr
	.globl	bcast_w_gpr
	.type	bcast_w_gpr, @function
bcast_w_gpr:                    ;! long(long, long, ptr)
	# Same regression, word form: source is a-b computed in-function.
	movl	%edi, %eax
	subl	%esi, %eax
	vpbroadcastw	%eax, %xmm0
	vmovdqu	%xmm0, (%rdx)
	xorl	%eax, %eax
	ret
	.size	bcast_w_gpr, .-bcast_w_gpr
	.globl	bcast_q_gpr
	.type	bcast_q_gpr, @function
bcast_q_gpr:                    ;! long(long, long, ptr)
	# Same regression, qword form: source is a^b computed in-function.
	movq	%rdi, %rax
	xorq	%rsi, %rax
	vpbroadcastq	%rax, %xmm0
	vmovdqu	%xmm0, (%rdx)
	xorl	%eax, %eax
	ret
	.size	bcast_q_gpr, .-bcast_q_gpr
	.section	.note.GNU-stack,"",@progbits
