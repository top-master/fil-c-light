	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr, long)
	# all-ones mask vector -> every lane enabled; lanes 0,1 read below the object
	vpcmpeqd	%ymm0, %ymm0, %ymm0
	vmaskmovps	(%rdi), %ymm0, %ymm1
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
