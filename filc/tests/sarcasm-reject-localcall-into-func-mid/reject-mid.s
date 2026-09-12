# UNSOUND: an unannotated call to a MID-BODY label of a signatured function
# (not an entry-adjacent alias). Entering mid-body skips the function's own
# frame setup, so the local-call clone semantics cannot apply — this keeps the
# ordinary annotate-the-callsite rejection.
	.text
	.globl	sum5
	.type	sum5, @function
sum5:                           #! void(ptr,long,long,long,long,long)
	movq	%rsi, %rax
.Lsum5_mid:
	addq	%rdx, %rax
	addq	%rcx, %rax
	addq	%r8, %rax
	addq	%r9, %rax
	movq	%rax, (%rdi)
	ret
	.size	sum5, .-sum5
	.globl	caller6
	.type	caller6, @function
caller6:                        #! void(ptr)
	movq	$1, %rsi
	movq	$2, %rdx
	movq	$3, %rcx
	movq	$4, %r8
	movq	$5, %r9
	call	.Lsum5_mid
	ret
	.size	caller6, .-caller6
	.section	.note.GNU-stack,"",@progbits
