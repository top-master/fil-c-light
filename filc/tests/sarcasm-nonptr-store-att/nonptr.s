# A store whose BASE web never received a pointer value -- here a pure integer
# constant loaded into %rbx -- compiles (the checker cannot prove the base is
# not an address) and traps at runtime with a null capability. Unlike the
# sarcasm-tm-nullcap-* cells, where the integer arrives from C as a null-cap
# `ptr` argument, the base here is constructed ENTIRELY inside the asm: the
# pin machinery must derive a null-object pin from a web with no pointer
# provenance at all, before any bytes are touched (no segfault).
	.text
	.globl	f
	.type	f, @function
f:                              ;! void(ptr)
	endbr64
	movq	%rdi, %rax
	movq	$8192, %rbx
	movq	%rax, (%rbx)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
