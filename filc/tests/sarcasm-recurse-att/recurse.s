	.text
	.globl	recurse
	.type	recurse, @function
recurse:                        ;! void(ptr)
	movq	%rdi, %rax
	call	recurse         ;! void(ptr)
	ret
	.size	recurse, .-recurse
	.section	.note.GNU-stack,"",@progbits
