	.text
	# Unaligned-capable vector moves (movups/movdqu) at odd offsets must pass:
	# x86 tolerates them in hardware, so sarcasm checks them with alignment 1
	# (like scalar accesses), not 16.
	.globl	movups_misaligned
	.type	movups_misaligned, @function
movups_misaligned:              ;! void(ptr, ptr)
	endbr64
	movups	1(%rsi), %xmm0
	movups	%xmm0, 1(%rdi)
	movdqu	3(%rsi), %xmm1
	movdqu	%xmm1, 3(%rdi)
	movups	17(%rsi), %xmm2
	movups	%xmm2, 17(%rdi)
	ret
	.size	movups_misaligned, .-movups_misaligned
	.section	.note.GNU-stack,"",@progbits
