	.text
	.globl	clobber
	.type	clobber, @function
clobber:                        ;! long()
	movq	$11, %rbx
	movq	$22, %r12
	movq	$33, %r13
	movq	$44, %r14
	movq	$55, %r15
	movl	$0x11223344, %eax
	movd	%eax, %xmm6
	movl	$0x55667788, %eax
	movd	%eax, %xmm7
	movl	$0x99aabbcc, %eax
	movd	%eax, %xmm8
	movl	g(%rip), %eax #! global ptr
	movl	g+4(%rip), %ecx #! global ptr
	addl	%ecx, %eax
	movd	%xmm6, %ecx
	addl	%ecx, %eax
	movd	%xmm7, %ecx
	addl	%ecx, %eax
	movd	%xmm8, %ecx
	addl	%ecx, %eax
	addq	%rbx, %rax
	addq	%r12, %rax
	addq	%r13, %rax
	addq	%r14, %rax
	addq	%r15, %rax
	ret
	.size	clobber, .-clobber
	.section	.note.GNU-stack,"",@progbits
