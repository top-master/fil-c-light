# Two paths into a join with DIFFERENT mid-function depths: the depth lattice
# cannot prove which frame slot a post-join rsp-relative access addresses (the
# merge degrades to the unknown "dyn" depth), so the access is rejected
# cleanly. (Each per-path inner frame is itself fine — it is the mismatched
# merge that is unsound.)
	.file	"midsp-mismatch.c"
	.text
	.globl	mismatch
	.type	mismatch, @function
mismatch:                       ;! long(long)
	pushq	%rbx
	subq	$16, %rsp
	testq	%rdi, %rdi
	jz	.Lsmall
	subq	$64, %rsp             # path A: depth 24 -> 88
	movq	$1, (%rsp)
	jmp	.Ljoin
.Lsmall:
	subq	$32, %rsp             # path B: depth 24 -> 56
	movq	$2, (%rsp)
.Ljoin:
	movq	(%rsp), %rax          # depth 88 vs 56: unprovable -> reject
	addq	$64, %rsp
	popq	%rbx
	ret
	.size	mismatch, .-mismatch
	.section	.note.GNU-stack,"",@progbits
