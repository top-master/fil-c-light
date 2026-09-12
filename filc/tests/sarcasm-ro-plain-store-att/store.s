	.file	"store.c"
	.text
	.globl	store_long
	.type	store_long, @function
store_long:                     ;! void(ptr, long)
	# a PLAIN (non-pointer) heap store to a read-only object must trap:
	# every heap write gets the CanWrite (not-readonly/special) check.
	movq	%rsi, (%rdi)
	ret
	.size	store_long, .-store_long
	.section	.note.GNU-stack,"",@progbits
