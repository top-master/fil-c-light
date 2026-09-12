	.file	"unpaired-pop-fp.c"
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(long)
	pushq	%rbp
	movq	%rsp, %rbp
	popq	%rbx
	movq	%rbx, %rax
	leave
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
