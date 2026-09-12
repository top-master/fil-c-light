	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr, ptr)
	# `;! load store ptr` (pointer RMW) is supported only on the
	# capability-preserving 8-byte ALU RMWs (add/adc/and/or/sbb/sub/xor,
	# inc/dec/neg/not): a shift of a pointer intval is not one of them.
	shlq	$3, (%rdi)      ;! load store ptr
	movq	%rsi, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
