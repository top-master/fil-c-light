	.text
	.globl	gstore
	.type	gstore, @function
gstore:                         ;! void(ptr)
	movq	%rdi, gp(%rip) #! store ptr
	ret
	.size	gstore, .-gstore
	.globl	gload
	.type	gload, @function
gload:                          ;! ptr()
	movq	gp(%rip), %rax #! load ptr
	ret
	.size	gload, .-gload
	.comm	gp,8,8
	.section	.note.GNU-stack,"",@progbits
