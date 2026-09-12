	.text
	.globl	copy32
	.type	copy32, @function
copy32:                         ;! void(ptr, ptr)
	movups	(%rsi), %xmm0
	movups	%xmm0, (%rdi)
	movdqu	16(%rsi), %xmm1
	movdqu	%xmm1, 16(%rdi)
	ret
	.size	copy32, .-copy32
	.globl	copy32_rev
	.type	copy32_rev, @function
copy32_rev:                     ;! void(ptr, ptr)
	movdqu	16(%rsi), %xmm2
	movups	(%rsi), %xmm3
	movups	%xmm3, (%rdi)
	movdqu	%xmm2, 16(%rdi)
	ret
	.size	copy32_rev, .-copy32_rev
	.section	.note.GNU-stack,"",@progbits
