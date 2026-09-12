	.text
	.globl	disps
	.type	disps, @function
disps:                          ;! long(ptr)
	movl	tab-4+8(%rip), %eax
	addl	tab+16-8(%rip), %eax
	movdqa	buf+512-128(%rip), %xmm7
	movd	%xmm7, %ecx
	addl	%ecx, %eax
	movl	512-128(%rdi), %ecx
	addl	%ecx, %eax
	ret
	.size	disps, .-disps
	.section	.rodata
	.p2align	4
tab:
	.long	100, 200, 300, 400
	.p2align	6
buf:
	.zero	384
	.long	1000, 2000, 3000, 4000
	.section	.note.GNU-stack,"",@progbits
