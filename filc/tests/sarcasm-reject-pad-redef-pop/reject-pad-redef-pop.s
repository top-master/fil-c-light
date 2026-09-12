# A pad-pushed register is redefined inside the pad, then popped, then read
# (no slot access at all): hardware loads the PUSHED value (0x6f) at the pop,
# but the paired pop is dropped and the read would see the redefined value
# (0xde). This miscompiled on the unmodified baseline too — the read after the
# pop is now rejected instead of silently wrong. The standard compiler
# prologue is unaffected: it reads nothing after its epilogue pops.
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	endbr64
	subq	$64, %rsp
	movl	$111, %ebx
	pushq	%rbx
	movl	$222, %ebx
	popq	%rbx
	movq	%rbx, %rax
	addq	$64, %rsp
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
