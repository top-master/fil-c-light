	.file	"domsize.c"
	.text
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	work
	.type	work, @function
work:                           ;! ptr()
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movl	$666, %eax      ;! alloca size (ptr)
.Lmid:
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movslq	%eax, %rsi
	movl	%eax, -68(%rbp)
	leaq	23(%rsi), %rax
	movq	%rsi, -64(%rbp)
	andq	$-16, %rax
	subq	%rax, %rsp
	leaq	15(%rsp), %rax
	movq	%rax, %rdi
	andq	$-16, %rdi      ;! alloca result (ptr)
	movq	%rdi, -56(%rbp)
	movl	-68(%rbp), %eax
	testl	%eax, %eax
	jle	.L2
	movq	-64(%rbp), %rsi
	xorl	%eax, %eax
	testb	$1, %sil
	jne	.L9
.L12:
	movq	-56(%rbp), %rcx
.L3:
	movb	%al, (%rcx,%rax)
	leaq	1(%rax), %rdx
	addq	$2, %rax
	movb	%dl, (%rcx,%rdx)
	cmpq	%rax, %rsi
	jne	.L3
.L2:
	movq	-56(%rbp), %rax
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L9:
	.cfi_restore_state
	movq	-56(%rbp), %rax
	cmpq	$1, -64(%rbp)
	movq	-64(%rbp), %rsi
	movb	$0, (%rax)
	movl	$1, %eax
	jne	.L12
	jmp	.L2
	.cfi_endproc
.LFE0:
	.size	work, .-work
.p2align 4
	.globl	work2
	.type	work2, @function
work2:                           ;! ptr()
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movl	$333, %eax      ;! alloca size (two)
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	testl	%eax, %eax
	je	.Lmid2
.Lmid2:
	movslq	%eax, %rsi
	movl	%eax, -68(%rbp)
	leaq	23(%rsi), %rax
	movq	%rsi, -64(%rbp)
	andq	$-16, %rax
	subq	%rax, %rsp
	leaq	15(%rsp), %rax
	movq	%rax, %rdi
	andq	$-16, %rdi      ;! alloca result (two)
	movq	%rdi, -56(%rbp)
	movl	-68(%rbp), %eax
	testl	%eax, %eax
	jle	.Q2
	movq	-64(%rbp), %rsi
	xorl	%eax, %eax
	testb	$1, %sil
	jne	.Q9
.Q12:
	movq	-56(%rbp), %rcx
.Q3:
	movb	%al, (%rcx,%rax)
	leaq	1(%rax), %rdx
	addq	$2, %rax
	movb	%dl, (%rcx,%rdx)
	cmpq	%rax, %rsi
	jne	.Q3
.Q2:
	movq	-56(%rbp), %rax
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.Q9:
	.cfi_restore_state
	movq	-56(%rbp), %rax
	cmpq	$1, -64(%rbp)
	movq	-64(%rbp), %rsi
	movb	$0, (%rax)
	movl	$1, %eax
	jne	.Q12
	jmp	.Q2
	.cfi_endproc
.LFE1:
	.size	work2, .-work2
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
