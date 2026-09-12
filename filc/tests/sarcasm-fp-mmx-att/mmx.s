	.text
	.globl	mmx_paddd
	.type	mmx_paddd, @function
mmx_paddd:                      ;! long(long, long)
	movq	%rdi, %mm0
	movq	%rsi, %mm1
	paddd	%mm1, %mm0
	movq	%mm0, %rax
	emms
	ret
	.size	mmx_paddd, .-mmx_paddd
	.globl	mmx_paddw_mem
	.type	mmx_paddw_mem, @function
mmx_paddw_mem:                  ;! long(ptr)
	movq	(%rdi), %mm0
	paddw	8(%rdi), %mm0
	movq	%mm0, %rax
	emms
	ret
	.size	mmx_paddw_mem, .-mmx_paddw_mem
	.section	.note.GNU-stack,"",@progbits
