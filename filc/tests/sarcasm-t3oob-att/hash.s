	.file	"test3.c"
	.text
	.globl	hash
	.type	hash, @function
hash:                           ;! unsigned(ptr)
.LFB16:
	.cfi_startproc
	cmpq	$0, 8(%rdi)
	je	.L4
	pushq	%r12
	movl	$5381, %eax
	movq	%rdi, %r12
	pushq	%rbp
	xorl	%ebp, %ebp
	pushq	%rbx
.L3:
	movq	%rax, %rdx
	movq	(%r12), %rdi    ;! load ptr
	movq	%rbp, %rsi
	addq	$1, %rbp
	salq	$5, %rdx
	leaq	(%rdx,%rax), %rbx
	call	foo@PLT         ;! int(ptr, size_t)
	cltq
	addq	%rbx, %rax
	cmpq	8(%r12), %rbp
	jb	.L3
	popq	%rbx
	popq	%rbp
	popq	%r12
	ret
.L4:
	movl	$5381, %eax
	ret
	.cfi_endproc
.LFE16:
	.size	hash, .-hash
	.section	.note.GNU-stack,"",@progbits
