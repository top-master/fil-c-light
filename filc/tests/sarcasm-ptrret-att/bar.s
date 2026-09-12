	.file	"ptrret.c"
	.text
	.globl	bar
	.type	bar, @function
bar:                            ;! ptr(ptr)
	movq	(%rdi), %rax    ;! load ptr
	ret
	.size	bar, .-bar
	.section	.note.GNU-stack,"",@progbits
