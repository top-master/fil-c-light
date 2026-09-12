# `#! load ptr` alone on a line attaches to an otherwise-empty statement, which
# the shared annotation validation rejects -- exactly like the `;!` form.
	.text
	.globl	f
	.type	f, @function
f:	#! void(ptr)
	movq	(%rdi), %rax #! load ptr
	#! store ptr
	ret
	.size	f, .-f
