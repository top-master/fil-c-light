	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 8-byte locked compare-and-swap (read-modify-write path).
	movl	$1, %eax
	movl	$2, %edx
	movl	$3, %ebx
	movl	$4, %ecx
	lock cmpxchg8b	(%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
