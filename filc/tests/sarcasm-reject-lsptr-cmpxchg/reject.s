	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr, ptr)
	# cmpxchg is a pointer compare-exchange: it needs `;! atomic ptr`, not
	# `;! load store ptr`
	cmpxchgq	%rsi, (%rdi)  ;! load store ptr
	movq	%rsi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
