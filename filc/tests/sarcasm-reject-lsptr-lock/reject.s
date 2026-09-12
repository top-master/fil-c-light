	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr, ptr)
	# `lock` on a non-atomic pointer RMW is a lie (the sequence is a
	# non-atomic load+op+store); use `;! atomic load store ptr`
	lock addq	%rsi, (%rdi)  ;! load store ptr
	movq	%rsi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
