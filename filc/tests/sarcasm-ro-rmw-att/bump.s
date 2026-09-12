	.file	"bump.c"
	.text
	.globl	bump
	.type	bump, @function
bump:                           ;! void(ptr, long)
	# a memory-destination RMW both reads and WRITES: the write-classified
	# access check (incl. CanWrite) must trap on a read-only object.
	addq	%rsi, (%rdi)
	ret
	.size	bump, .-bump
	.section	.note.GNU-stack,"",@progbits
