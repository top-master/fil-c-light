	.file	"stackbuf.c"
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! void(ptr, size_t)
	subq	$288, %rsp
	leaq	-120(%rsp), %rcx   ;! alloca result size=400
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
	addq	$288, %rsp
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
