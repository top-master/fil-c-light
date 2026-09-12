# push/pop of a segment register TRANSFERS the segment selector (a push only
# READS it; a pop's selector load rides the stack push/pop machinery). The old
# routing reported a push with the "writes to a segment register" message even
# though push reads the selector; push/pop now get their own accurate message.
# Either way the selector transfer is not modeled and stays rejected (a
# selector WRITE, e.g. `mov %ax, %fs`, keeps the write-specific message — see
# sarcasm-reject-seg-write).
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	endbr64
	movq	%rdi, %rax
	pushq	%fs
	popq	%rcx
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
