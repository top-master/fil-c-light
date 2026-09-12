	.file	"test.c"
	.text
	.p2align 4
	.globl	hash
	.type	hash, @function
hash:                           ;! unsigned(ptr)
.LFB0:
	.cfi_startproc
	movzbl	(%rdi), %edx
	leaq	1(%rdi), %rcx
	movl	$5381, %eax
	testb	%dl, %dl
	je	.L4
.L3:
	movq	%rax, %rsi
	addq	$1, %rcx
	salq	$5, %rsi
	addq	%rsi, %rax
	addq	%rdx, %rax
	movzbl	-1(%rcx), %edx
	testb	%dl, %dl
	jne	.L3
	ret
.L4:
	ret
	.cfi_endproc
.LFE0:
	.size	hash, .-hash
	.section	.note.GNU-stack,"",@progbits
