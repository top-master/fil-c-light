# Three branch-free dynamic-alloca functions whose %rsp recovery sits in the SAME
# straight-line region as the `;! alloca result` annotation -- no label separates them.
# Each recovery is a form the deferred-alloca discovery must NOT swallow as alloca
# machinery: rec recovers from the frame pointer (mov form), rec2 recovers from the
# frame pointer with only the frame pointer pushed, and rec3 recovers from the
# prologue rsp save parked in %rbx.
	.text
	.globl	rec
	.type	rec, @function
rec:                            ;! long()
	endbr64
	pushq	%rbp
	pushq	%rbx
	movq	%rsp, %rbp
	subq	$24, %rsp
	movl	$96, %eax           ;! alloca size (b1)
	movq	%rax, %rcx          # the deferred-idiom size chain
	leaq	15(%rcx), %rdx
	andq	$-16, %rdx
	subq	%rdx, %rsp          # the dynamic allocation: the depth becomes unknown...
	leaq	15(%rsp), %rsi
	movq	%rsi, %rdi
	andq	$-16, %rdi          ;! alloca result (b1)
	movq	%rdi, -24(%rbp)     # ...but rbp-relative traffic still works through it
	movq	-24(%rbp), %rax
	movq	$16909060, (%rax)   # bytes 04 03 02 01 (little-endian)
	movzbl	1(%rax), %edx       # 0x03
	movzbl	2(%rax), %esi       # 0x02
	addq	%rdx, %rsi
	movq	-24(%rbp), %rax
	movzbl	3(%rax), %edx       # 0x01
	addq	%rdx, %rsi
	movq	%rsi, %rax          # return 3 + 2 + 1 = 6
	movq	%rbp, %rsp          # recover %rsp from the frame pointer: NO label before this
	popq	%rbx                # pairs with the prologue push of %rbx
	popq	%rbp                # pairs with the saved frame pointer
	ret
	.size	rec, .-rec
	.globl	rec2
	.type	rec2, @function
rec2:                           ;! long()
	endbr64
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$24, %rsp
	movl	$64, %eax           ;! alloca size (b2)
	movq	%rax, %rcx
	leaq	15(%rcx), %rdx
	andq	$-16, %rdx
	subq	%rdx, %rsp
	leaq	15(%rsp), %rsi
	movq	%rsi, %rdi
	andq	$-16, %rdi          ;! alloca result (b2)
	movq	%rdi, -16(%rbp)
	movq	-16(%rbp), %rax
	movq	$258, (%rax)        # bytes 02 01
	movzbl	(%rax), %edx        # 0x02
	movzbl	1(%rax), %esi       # 0x01
	addq	%rdx, %rsi
	movq	%rsi, %rax          # return 2 + 1 = 3
	movq	%rbp, %rsp          # recover %rsp from the frame pointer: NO label before this
	popq	%rbp                # pairs with the saved frame pointer
	ret
	.size	rec2, .-rec2
	.globl	rec3
	.type	rec3, @function
rec3:                           ;! long()
	endbr64
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	movq	%rsp, %rbx          # the prologue parks %rsp in %rbx (a callee-saved register)
	subq	$24, %rsp
	movl	$80, %eax           ;! alloca size (b3)
	movq	%rax, %rcx
	leaq	15(%rcx), %rdx
	andq	$-16, %rdx
	subq	%rdx, %rsp
	leaq	15(%rsp), %rsi
	movq	%rsi, %rdi
	andq	$-16, %rdi          ;! alloca result (b3)
	movq	%rdi, -16(%rbp)
	movq	-16(%rbp), %rax
	movq	$67438087, (%rax)   # bytes 07 06 05 04
	movzbl	(%rax), %edx        # 0x07
	movzbl	1(%rax), %esi       # 0x06
	addq	%rdx, %rsi
	movq	-16(%rbp), %rax
	movzbl	2(%rax), %edx       # 0x05
	addq	%rdx, %rsi
	movq	%rsi, %rax          # return 7 + 6 + 5 = 18
	movq	%rbx, %rsp          # recover %rsp from the prologue save: NO label before this
	popq	%rbx                # pairs with the prologue push of %rbx
	popq	%rbp                # pairs with the saved frame pointer
	ret
	.size	rec3, .-rec3
	.section	.note.GNU-stack,"",@progbits
