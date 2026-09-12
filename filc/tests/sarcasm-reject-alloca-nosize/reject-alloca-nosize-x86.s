	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	movq	%rsp, %rax   ;! alloca result (a)
	ret
	.size	f, .-f
