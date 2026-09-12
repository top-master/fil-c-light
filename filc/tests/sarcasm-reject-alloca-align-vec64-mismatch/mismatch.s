# An aligned-vector store to an ORDINARY (16-byte-aligned) alloca region: the
# region cannot prove 32-byte alignment, so this is a compile-time rejection
# (deterministic -- not a runtime trap that depends on the GC payload's
# alignment). Use `align=32` (or the unaligned form) instead.
	.text
	.globl	mismatch
	.type	mismatch, @function
mismatch:                       ;! void(ptr)
	subq	$96, %rsp
	leaq	0(%rsp), %rcx       ;! alloca result size=64
	vmovdqu	(%rdi), %ymm0
	vmovdqa	%ymm0, 0(%rsp)      # needs 32, the region proves only 16: reject
	addq	$96, %rsp
	ret
	.size	mismatch, .-mismatch
	.section	.note.GNU-stack,"",@progbits
