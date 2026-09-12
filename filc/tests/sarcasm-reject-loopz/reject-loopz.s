# The ZF-consuming loop variants (loope/loopz/loopne/loopnz) branch on the
# FLAGS left by the PRECEDING instruction. Sarcasm's injected memory-access
# checks clobber EFLAGS (the documented known issue), so the pending condition
# could be silently polluted between the flag producer and the loop — the
# branch cannot be proven sound. Plain `loop` branches on the decremented
# counter instead and stays supported.
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	endbr64
	movq	%rdi, %rax
	testq	%rax, %rax
	loope	.Ldone
	loopne	.Ldone
	movq	$0, %rax
	ret
.Ldone:
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
