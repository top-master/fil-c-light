# A frame-address lea CLUSTER (the bsaes shape): a lea into an alloca region
# whose result is copied and offset — the region-pointer capability flows
# through the copy/offset chain and accesses happen through three derived
# registers. ptrflow propagates the lower through the copies; the frame pass
# and the region redirect keep every derived access region-based.
	.text
	.globl	cluster
	.type	cluster, @function
cluster:                        #! long(long)
	subq	$136, %rsp
	movq	%rsp, %rbx          ;! alloca result size=128
	leaq	32(%rsp), %rdi      # lea into the region (region+32)
	movq	%rdi, %rsi          # copy 1 of the region pointer
	leaq	8(%rsi), %rdx       # offset of the copy (derived lea): region+40
	movq	%rdi, %rcx          # copy 2
	movq	$100, (%rdi)        # writes through the three derived registers
	movq	$101, (%rsi)
	movq	$102, (%rdx)
	movq	$103, (%rcx)
	movq	32(%rbx), %rax      # read back: region+32 = 103 (last writer), +40 = 102
	addq	40(%rbx), %rax
	addq	$136, %rsp
	ret
	.size	cluster, .-cluster
	.section	.note.GNU-stack,"",@progbits
