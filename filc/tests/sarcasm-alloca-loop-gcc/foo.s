	.file	"alloca_loop.c"
	.text
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	foo
	.type	foo, @function
foo:   #! void(int, int)
.LFB0:
	.cfi_startproc
	endbr64
	testl	%edi, %edi
	je	.L18
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
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
	movl	%edi, -72(%rbp)
	movl	%esi, -76(%rbp)
	.p2align 4,,10
	.p2align 3
.L5:
	movl	-76(%rbp), %eax
	movslq	%eax, %rsi
	movl	%eax, -68(%rbp)
	leaq	23(%rsi), %rax
	movq	%rsi, -64(%rbp)
	andq	$-16, %rax      #! alloca size (ptr)
	subq	%rax, %rsp
	leaq	15(%rsp), %rax
	movq	%rax, %rbx
	andq	$-16, %rbx      #! alloca result (ptr) 
	movq	%rbx, -56(%rbp)
	movl	-68(%rbp), %eax
	testl	%eax, %eax
	jle	.L3
	movq	-64(%rbp), %rsi
	xorl	%eax, %eax
	testb	$1, %sil
	je	.L21
	movq	-56(%rbp), %rax
	cmpq	$1, -64(%rbp)
	movq	-64(%rbp), %rsi
	movb	$0, (%rax)
	movl	$1, %eax
	je	.L3
.L21:
	movq	-56(%rbp), %rcx
.L4:
	movb	%al, (%rcx,%rax)
	leaq	1(%rax), %rdx
	addq	$2, %rax
	movb	%dl, (%rcx,%rdx)
	cmpq	%rax, %rsi
	jne	.L4
.L3:
	movq	-56(%rbp), %rax
	subl	$1, -72(%rbp)
	jne	.L5
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
.L18:
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
	.cfi_restore 15
	ret
	.cfi_endproc
.LFE0:
	.size	foo, .-foo
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
