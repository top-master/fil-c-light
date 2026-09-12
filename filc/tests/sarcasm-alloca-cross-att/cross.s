# Two allocas in one function are INDEPENDENT GC allocations, not adjacent
# regions of one frame: advancing A's pointer by exactly A's size -- where B
# would sit if these were real stack allocations -- lands ON A's upper bound,
# and a store through it traps (ptr >= upper). The real-frame intuition "the
# next alloca starts right after mine" must not transfer to the GC allocations.
	.text
	.globl	cross
	.type	cross, @function
cross:                          ;! void()
	endbr64
	movq	$0, %rax
	leaq	-120(%rsp), %rcx    ;! alloca result size=64
	leaq	-200(%rsp), %r8     ;! alloca result size=64
	movq	$119, (%rcx)
	movq	$136, (%r8)
	addq	$64, %rcx           # one past the end of A (where B would sit)
	movq	$153, (%rcx)        # must trap
	ret
	.size	cross, .-cross
	.section	.note.GNU-stack,"",@progbits
