	.file	"midframe-unbalanced.c"
	.text
	.globl	f
	.type	f, @function
f:                              ;! long()
	subq	$16, %rsp
	movq	$5, (%rsp)
	pushq	%rbx
	je	.Lskip
	popq	%rbx
.Lskip:
	movq	(%rsp), %rax
	addq	$16, %rsp
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
