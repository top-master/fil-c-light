	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	# 16-byte locked compare-and-swap (read-modify-write path); offsets stay 16-aligned so attribution stays on the bounds/flags messages.
	movq	$1, %rax
	movq	$2, %rdx
	movq	$3, %rbx
	movq	$4, %rcx
	lock cmpxchg16b	(%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
