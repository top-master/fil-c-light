	.file	"jmp-perturbed.c"
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(long)
	pushq	%rbx
	jmp	*%rdi
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
