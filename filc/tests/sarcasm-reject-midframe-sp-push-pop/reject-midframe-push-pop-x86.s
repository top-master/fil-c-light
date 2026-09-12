	.file	"midframe-push-pop.c"
# A stack access OVERLAPPING a mid-function pushed register's save slot is
# still rejected when it cannot re-sync the pushed register's web: a
# PARTIAL-WIDTH store into the pad (the model has no subregister view — the
# remaining slot bytes would keep the pre-push value the dropped pop
# restores). (A non-aliased access at a statically known perturbed depth —
# e.g. the frame slot above the pad — keys exactly in normalized coordinates
# and is now accepted.)
	.text
	.globl	f
	.type	f, @function
f:                              ;! long()
	subq	$16, %rsp
	movq	$5, (%rsp)
	pushq	%rbx
	movb	$6, (%rsp)
	popq	%rbx
	movq	(%rsp), %rax
	addq	$16, %rsp
	ret
	.size	f, .-f
	.section	.note.GNU-stack,"",@progbits
