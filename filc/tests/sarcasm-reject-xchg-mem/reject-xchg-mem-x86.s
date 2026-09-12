# `xchg` with a memory operand is an implicitly LOCKED read-modify-write in
# hardware (the lock happens with or without a `lock` prefix) and is not one of
# the exactly-modeled memory RMWs, so it must stay a compile-time rejection --
# now with its own precise message instead of the generic
# "cannot determine the memory access width" one.
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	endbr64
	movq	%rdi, %rax
	xchgq	%rax, (%rdi)
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
