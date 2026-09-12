	.file	"store.c"
	.text
	.globl	store_double
	.type	store_double, @function
store_double:                   ;! void(ptr, long)
	# an FP/SIMD heap store to a read-only object must trap too: every heap
	# write path funnels through the same CanWrite-checked access check.
	movq	%rsi, %xmm0
	movsd	%xmm0, (%rdi)
	ret
	.size	store_double, .-store_double
	.section	.note.GNU-stack,"",@progbits
