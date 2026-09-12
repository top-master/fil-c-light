	.file	"test2.c"
	.text
	.globl	hash
	.type	hash, @function
hash:                           ;! unsigned(ptr)
	movq	8(%rdi), %rsi
	testq	%rsi, %rsi
	je	.L4
	movq	(%rdi), %rdx    ;! load ptr
	movl	$5381, %eax
	addq	%rdx, %rsi
.L3:
	movq	%rax, %rcx
	addq	$1, %rdx
	salq	$5, %rcx
	addq	%rcx, %rax
	movzbl	-1(%rdx), %ecx
	addq	%rcx, %rax
	cmpq	%rsi, %rdx
	jne	.L3
	ret
.L4:
	movl	$5381, %eax
	ret
	.size	hash, .-hash
	.section	.note.GNU-stack,"",@progbits
