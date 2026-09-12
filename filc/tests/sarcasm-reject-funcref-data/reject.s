	.text
	.globl	f
	.type	f, @function
f:                              #! void()
	# `#! funcref` materializes a FUNCTION's flight pointer; a data target
	# has no function object, so this is a clean compile-time rejection.
	leaq	mydata(%rip), %rax #! funcref
	ret
	.size	f, .-f
	.data
	.globl	mydata
	.p2align	2
mydata:
	.long	0
	.section	.note.GNU-stack,"",@progbits
