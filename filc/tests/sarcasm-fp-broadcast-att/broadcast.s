	.text
	.globl	bcast_b
	.type	bcast_b, @function
bcast_b:                        ;! long(ptr, ptr)
	# vpbroadcastb loads ONE byte from memory and broadcasts it to all 32 ymm
	# lanes: the memory operand must be checked at element width (1 byte), not
	# at the full 32-byte vector width.
	vpbroadcastb	(%rdi), %ymm0
	vmovdqu	%ymm0, (%rsi)
	xorl	%eax, %eax
	ret
	.size	bcast_b, .-bcast_b
	.globl	bcast_w
	.type	bcast_w, @function
bcast_w:                        ;! long(ptr, ptr)
	# 2-byte element load broadcast to 16 word lanes.
	vpbroadcastw	(%rdi), %ymm0
	vmovdqu	%ymm0, (%rsi)
	xorl	%eax, %eax
	ret
	.size	bcast_w, .-bcast_w
	.globl	bcast_d
	.type	bcast_d, @function
bcast_d:                        ;! long(ptr, ptr)
	# 4-byte element load broadcast to 8 dword lanes.
	vpbroadcastd	(%rdi), %ymm0
	vmovdqu	%ymm0, (%rsi)
	xorl	%eax, %eax
	ret
	.size	bcast_d, .-bcast_d
	.globl	bcast_q
	.type	bcast_q, @function
bcast_q:                        ;! long(ptr, ptr)
	# 8-byte element load broadcast to 4 qword lanes.
	vpbroadcastq	(%rdi), %ymm0
	vmovdqu	%ymm0, (%rsi)
	xorl	%eax, %eax
	ret
	.size	bcast_q, .-bcast_q
	.globl	bcast_d_reg
	.type	bcast_d_reg, @function
bcast_d_reg:                    ;! long(ptr, ptr)
	# xmm-source broadcast: no memory operand on the broadcast itself (the
	# element is loaded separately). All lanes must equal the source dword.
	vmovd	(%rdi), %xmm1
	vpbroadcastd	%xmm1, %ymm0
	vmovdqu	%ymm0, (%rsi)
	xorl	%eax, %eax
	ret
	.size	bcast_d_reg, .-bcast_d_reg
	.section	.note.GNU-stack,"",@progbits
