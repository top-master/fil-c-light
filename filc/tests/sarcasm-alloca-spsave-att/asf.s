	.text
	.globl	asf
	.type	asf, @function
asf:                            ;! ptr(long)
	endbr64
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	movq	%rsp, %rbx          # the prologue parks %rsp in %rbx (a callee-saved register)
	subq	$24, %rsp
	movq	%rdi, %rax          ;! alloca size (s)
	movq	%rax, -24(%rbp)     # spill the size through an rbp-relative slot
	leaq	23(%rax), %rcx
	andq	$-16, %rcx
	subq	%rcx, %rsp          # the dynamic allocation: the depth becomes unknown...
	leaq	15(%rsp), %rdx
	movq	%rdx, %rdi
	andq	$-16, %rdi          ;! alloca result (s)
	movq	%rdi, -16(%rbp)     # ...but rbp-relative traffic still works through it
	movq	-24(%rbp), %rsi     # n
	movq	-16(%rbp), %rdx     # buffer
	xorl	%ecx, %ecx
	testq	%rsi, %rsi
	jle	.Ldone
.Lfill:
	movb	%cl, (%rdx,%rcx)
	incq	%rcx
	cmpq	%rcx, %rsi
	jne	.Lfill
.Ldone:
	movq	%rbx, %rsp          # recover %rsp from the prologue save: revives a KNOWN depth
	movq	-16(%rbp), %rax     # rbp-relative traffic AFTER the recovery (%rbp is static)
	popq	%rbx                # pairs with the prologue push of %rbx
	popq	%rbp                # pairs with the saved frame pointer
	ret
	.size	asf, .-asf
	.section	.note.GNU-stack,"",@progbits
