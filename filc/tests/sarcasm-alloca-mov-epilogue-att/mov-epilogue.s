	.file	"alloca.c"
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! void(ptr, size_t)
	pushq	%rbp
	leaq	23(,%rsi,4), %rax
	andq	$-16, %rax
	movq	%rsp, %rbp
	subq	%rax, %rsp      ;! alloca size (buf)
	leaq	15(%rsp), %rcx  ;! alloca result (buf)
	andq	$-16, %rcx
	testq	%rsi, %rsi
	je	.L1
	leaq	-1(%rsi), %rax
	movq	%rax, %rdx
.L3:
	movl	(%rdi,%rdx,4), %esi
	movl	%esi, (%rcx,%rdx,4)
	subq	$1, %rdx
	jnb	.L3
.L4:
	movl	(%rcx,%rax,4), %edx
	movl	%edx, (%rdi,%rax,4)
	subq	$1, %rax
	jnb	.L4
.L1:
	movq	%rbp, %rsp
	popq	%rbp
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
