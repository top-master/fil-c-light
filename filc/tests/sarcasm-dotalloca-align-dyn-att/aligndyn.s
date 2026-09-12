	.text
	# `.alloca` with a dynamic (register) alignment: the returned pointer
	# satisfies the runtime alignment.
	.globl	dotalloca_adyn
	.type	dotalloca_adyn, @function
dotalloca_adyn:                 ;! ptr(long, long)
	endbr64
	.alloca %rdi, %rsi, %rax
	ret
	.size	dotalloca_adyn, .-dotalloca_adyn
	.section	.note.GNU-stack,"",@progbits
