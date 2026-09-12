	.text
	.globl	ktab_get
	.type	ktab_get, @function
ktab_get:                       ;! long(long)
	leaq	ktab(%rip), %rax
	movl	(%rax,%rdi,4), %eax
	ret
	.size	ktab_get, .-ktab_get
	.globl	ktab_vec
	.type	ktab_vec, @function
ktab_vec:                       ;! void(ptr,long)
	leaq	ktab(%rip), %rax
	movdqa	(%rax,%rsi), %xmm0
	movdqa	%xmm0, (%rdi)
	ret
	.size	ktab_vec, .-ktab_vec
	.section	.rodata
	.p2align	4
ktab:
	.long	0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5
	.long	0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5
	.section	.note.GNU-stack,"",@progbits
