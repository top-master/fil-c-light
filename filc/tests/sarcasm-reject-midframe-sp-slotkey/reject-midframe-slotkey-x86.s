# A mid-function constant `subq $8, %rsp` / `addq $8, %rsp` pad at a statically
# known depth. Historically rejected wholesale as a "mid-function stack-pointer
# adjustment"; with static depth tracking through mid-function sp writes the two
# stores key to DISTINCT normalized frame slots ((%rsp) at depth 16 is frame
# offset 0, (%rsp) at depth 24 is frame offset -8) and the shape is accepted:
# the reload returns the FIRST store's value (5).
	.file	"midframe-slotkey.c"
	.text
	.globl	f
	.type	f, @function
f:                              ;! long()
	subq	$16, %rsp
	movq	$5, (%rsp)
	subq	$8, %rsp
	movq	$6, (%rsp)
	addq	$8, %rsp
	movq	(%rsp), %rax
	addq	$16, %rsp
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
