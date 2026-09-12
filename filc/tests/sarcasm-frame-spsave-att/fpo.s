	.text
	.globl	fpo1
	.type	fpo1, @function
fpo1:                           ;! long(long)
	endbr64
	pushq	%rbx
	movq	%rsp, %rbx          # the prologue parks %rsp in %rbx (a callee-saved register)
	subq	$16, %rsp
	movq	%rdi, 0(%rsp)       # rsp-relative slot traffic at the post-prologue depth
	movq	0(%rsp), %rax
	addq	$5, %rax
	movq	%rax, 8(%rsp)
	movq	8(%rsp), %rax
	movq	%rbx, %rsp          # recover %rsp from the prologue save (dropped)
	popq	%rbx                # pairs with the prologue push (dropped)
	ret
	.size	fpo1, .-fpo1
	.globl	fpo2
	.type	fpo2, @function
fpo2:                           ;! long(long)
	endbr64
	pushq	%r12
	movq	%rsp, %r12          # a second save register; TWO recoveries from it
	subq	$16, %rsp
	movq	%rdi, 0(%rsp)
	movq	0(%rsp), %rax
	addq	$5, %rax
	movq	%rax, 8(%rsp)
	movq	8(%rsp), %rax
	movq	%r12, %rsp          # recovery #1 (the register still holds the save)
	movq	%r12, %rsp          # recovery #2 — still valid: the recovery leaves it alone
	popq	%r12                # pairs with the prologue push
	ret
	.size	fpo2, .-fpo2
	.globl	fpo3
	.type	fpo3, @function
fpo3:                           ;! long(long)
	endbr64
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	movq	%rsp, %rbx          # the rsp save; %rbx is also a pushed callee-saved register
	subq	$16, %rsp
	movq	%rdi, -16(%rbp)     # rbp-relative slot traffic
	movq	%rbx, %rsp          # recover %rsp from the save...
	movq	-16(%rbp), %rax     # ...and keep doing rbp-relative traffic: %rbp is static
	addq	$1, %rax
	popq	%rbx                # pairs with the pushed save
	popq	%rbp                # pairs with the saved frame pointer
	ret
	.size	fpo3, .-fpo3
	.globl	fpo4
	.type	fpo4, @function
fpo4:                           ;! long(long)
	endbr64
	pushq	%rbx
	movq	%rsp, %rbx
	subq	$24, %rsp
	movq	%rdi, 0(%rsp)
	movq	0(%rsp), %rax
	addq	$5, %rax
	movq	%rbx, %rsp          # recover %rsp from the save...
	addq	$8, %rsp            # ...then a constant teardown that discards the pushed %rbx
	ret
	.size	fpo4, .-fpo4
	.section	.note.GNU-stack,"",@progbits
