	.text
	.globl	sum2
	.type	sum2, @function
sum2:                           ;! unsigned long(ptr, ptr)
	xorl	%eax, %eax
.L1:
	movq	(%rdi), %rcx      ;! load ptr
	testq	%rcx, %rcx
	je	.L2
	movq	(%rsi), %rdx      ;! load ptr
	movzbl	(%rcx), %ecx
	movzbl	(%rdx), %edx
	addq	%rcx, %rax
	addq	%rdx, %rax
	addq	$8, %rdi
	addq	$8, %rsi
	jmp	.L1
.L2:
	ret
	.size	sum2, .-sum2
	.section	.note.GNU-stack,"",@progbits
