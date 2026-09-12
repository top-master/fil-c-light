# Intel-syntax twin of sarcasm-nonptr-store-att: a store whose BASE web never
# received a pointer value -- here a pure integer constant loaded into ebx --
# compiles (the checker cannot prove the base is not an address) and traps at
# runtime with a null capability, before any bytes are touched (no segfault).
	.intel_syntax noprefix
	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	endbr64
	mov	rax, rdi
	mov	rbx, 8192
	mov	[rbx], rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
