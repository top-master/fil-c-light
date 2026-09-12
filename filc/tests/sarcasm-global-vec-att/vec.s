	.text
	.globl	vecload
	.type	vecload, @function
vecload:                        ;! void(ptr)
	movdqa	ktab+512(%rip), %xmm7
	vmovdqu	%xmm7, (%rdi)
	movdqa	ktab+512+16(%rip), %xmm7
	vmovdqu	%xmm7, 16(%rdi)
	vmovdqu	atab(%rip), %xmm6
	vmovdqu	%xmm6, 32(%rdi)
	vmovdqu	atab+16(%rip), %xmm6
	vmovdqu	%xmm6, 48(%rdi)
	ret
	.size	vecload, .-vecload
	.section	.rodata
	.p2align	6
ktab:
	.zero	512
	.long	1, 2, 3, 4
	.long	5, 6, 7, 8
	.p2align	6
atab:
	.byte	1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
	.byte	16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1
	.byte	1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
	.byte	16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1
	.section	.note.GNU-stack,"",@progbits
