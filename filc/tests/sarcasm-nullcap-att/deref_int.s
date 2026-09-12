	.file	"nullcap.c"
	.text
	.globl	deref_int
	.type	deref_int, @function
deref_int:                      ;! int(int)
	movl	(%rdi), %eax
	ret
	.size	deref_int, .-deref_int
	.section	.note.GNU-stack,"",@progbits
