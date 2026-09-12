	.text
	.globl	cas16
	.type	cas16, @function
cas16:                          ;! void(ptr)
	movq	$1, %rax
	movq	$2, %rdx
	movq	$3, %rbx
	movq	$4, %rcx
	lock cmpxchg16b	(%rdi)
	ret
	.size	cas16, .-cas16
	.section	.note.GNU-stack,"",@progbits
