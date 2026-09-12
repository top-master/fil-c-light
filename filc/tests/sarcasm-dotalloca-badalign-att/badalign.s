	.text
	# A non-power-of-two dynamic `.alloca` alignment traps cleanly.
	.globl	dotalloca_badalign
	.type	dotalloca_badalign, @function
dotalloca_badalign:             ;! ptr(long, long)
	endbr64
	.alloca %rdi, %rsi, %rax
	ret
	.size	dotalloca_badalign, .-dotalloca_badalign
	.section	.note.GNU-stack,"",@progbits
