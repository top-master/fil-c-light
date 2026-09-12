	.text
	# `.alloca` alignment correctness: each returned pointer satisfies its
	# alignment, and the whole size is writable through it.
	.globl	dotalloca_a16
	.type	dotalloca_a16, @function
dotalloca_a16:                  ;! ptr()
	endbr64
	.alloca $48, $16, %rax
	ret
	.size	dotalloca_a16, .-dotalloca_a16
	.globl	dotalloca_a32
	.type	dotalloca_a32, @function
dotalloca_a32:                  ;! ptr()
	endbr64
	.alloca $48, $32, %rax
	ret
	.size	dotalloca_a32, .-dotalloca_a32
	.globl	dotalloca_a64
	.type	dotalloca_a64, @function
dotalloca_a64:                  ;! ptr()
	endbr64
	.alloca $48, $64, %rax
	ret
	.size	dotalloca_a64, .-dotalloca_a64
	.globl	dotalloca_a128
	.type	dotalloca_a128, @function
dotalloca_a128:                 ;! ptr()
	endbr64
	.alloca $200, $128, %rax
	ret
	.size	dotalloca_a128, .-dotalloca_a128
	.section	.note.GNU-stack,"",@progbits
