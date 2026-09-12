	.text
	.globl	store8
	.type	store8, @function
store8:                         ;! void(ptr, long)
	movq	%rsi, %xmm0
	movsd	%xmm0, (%rdi)
	ret
	.size	store8, .-store8
	.globl	load8
	.type	load8, @function
load8:                          ;! long(ptr)
	movsd	(%rdi), %xmm0
	movq	%xmm0, %rax
	ret
	.size	load8, .-load8
	.globl	store4
	.type	store4, @function
store4:                         ;! void(ptr, long)
	movd	%esi, %xmm0
	movss	%xmm0, (%rdi)
	ret
	.size	store4, .-store4
	.globl	load4
	.type	load4, @function
load4:                          ;! long(ptr)
	movss	(%rdi), %xmm0
	movd	%xmm0, %eax
	ret
	.size	load4, .-load4
	.section	.note.GNU-stack,"",@progbits
