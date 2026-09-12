# A mid-function `pushq %rax` / `popq %rax` spill round-trip of a caller-saved
# register at a statically known depth. Historically rejected ("mid-function
# push/pop of a non-callee-saved operand"); the spill push is now an ordinary
# frame-slot store and its matching pop an ordinary slot load, so the shape is
# accepted (the slot value is dead either way — the reload from the frame
# returns 5).
	.file	"mid-pushpop.c"
	.text
	.globl	f
	.type	f, @function
f:                              ;! long()
	subq	$16, %rsp
	movq	$5, (%rsp)
	pushq	%rax
	popq	%rax
	movq	(%rsp), %rax
	addq	$16, %rsp
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
