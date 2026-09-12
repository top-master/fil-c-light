# A branch join merges %rax's two defs (copied from two different pointer
# origins, %rdi and %rsi) into one register web. The web's runtime value comes
# from either origin, so its capability lower must be a PHI of the two origins'
# lowers — ptrflow's dynamic-lower widening emits a lockstep lower copy on each
# branch, and the `;! store ptr` below checks against whichever capability the
# executed branch produced. (This used to be rejected as a pointer-flow
# non-convergence; the rejection was over-conservative — no single STATIC lower
# exists, but the dynamic one is exact.)
	.text
	.globl	join_store
	.type	join_store, @function
join_store:                     ;! void(ptr, ptr)
	endbr64
	movq	(%rdi), %rcx      # scalar condition (plain load, not a pointer source)
	testq	%rcx, %rcx
	je	.L1
	movq	%rdi, %rax
	jmp	.L2
.L1:
	movq	%rsi, %rax
.L2:
	movq	%rdi, (%rax)    ;! store ptr
	ret
	.size	join_store, .-join_store
	.section	.note.GNU-stack,"",@progbits
