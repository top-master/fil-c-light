# A transient mid-function `subq $8, %rsp; addq $8, %rsp` pad around the frame
# slot holding the argument. Historically rejected as a "mid-function
# stack-pointer adjustment"; with static depth tracking through mid-function sp
# writes the pad is an ordinary depth change and the slot web stays exact:
# f(42) returns 42.
	.file	"midframe-pad.c"
	.text
	.globl	f
	.type	f, @function
f:                              ;! long(long)
	subq	$16, %rsp
	movq	%rdi, (%rsp)
	subq	$8, %rsp
	addq	$8, %rsp
	movq	(%rsp), %rax
	addq	$16, %rsp
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
