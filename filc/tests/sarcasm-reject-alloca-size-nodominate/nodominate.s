	.file	"nodominate.c"
	.text
	.globl	nodom
	.type	nodom, @function
nodom:                          ;! ptr()
	endbr64
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movl	$666, %eax
	testl	%eax, %eax
	je	.Lskip
	movl	$666, %eax      ;! alloca size (ptr)
.Lskip:
	movslq	%eax, %rsi
	andq	$-16, %rax
	subq	%rax, %rsp
	leaq	15(%rsp), %rax
	movq	%rax, %rdi
	andq	$-16, %rdi      ;! alloca result (ptr)
	movq	%rbp, %rsp
	popq	%rbp
	ret
	.size	nodom, .-nodom
	.section	.note.GNU-stack,"",@progbits
