# A segment-QUALIFIED memory operand (`movq %fs:0x28, %rax` — the stack-canary
# idiom) reads through a segment base the checker cannot see. The %fs/%gs bases
# are runtime-owned, and the displacement is an absolute address in a space
# sarcasm does not model, so the access cannot be bounds-checked: it used to be
# seen as a plain global access and rejected only by the symbolic-address error
# path late in the pipeline; it is now rejected up front like any symbolic
# memory operand. (Moves INTO a segment register are a separate rejection --
# sarcasm-reject-seg-write -- and plain selector reads like `movl %fs, %eax`
# keep passing through.)
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(ptr)
	endbr64
	movq	%rdi, %rax
	movq	%fs:0x28, %rax
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
