	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr, ptr)
	# `lock` is only allowed on memory-destination read-modify-write
	# instructions sarcasm models exactly (add/adc/and/or/sbb/sub/xor,
	# inc/dec/neg/not, xadd, cmpxchg, cmpxchg8b/16b). mov is not one: reject.
	lock movq	%rsi, (%rdi)
	movq	%rsi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
