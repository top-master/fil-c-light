	.file	"unpaired-pop-frame.c"
	.text
	.globl	f
	.type	f, @function
f:                              ;! long()
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	$5, (%rsp)
	popq	%rbx
	movq	%rbx, %rax
	leave
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
