# Store-to-slot, then REDEFINE the register, then pop, then read: hardware
# loads the STORED value (0x4141414141414141) into the register at the pop and
# the read sees it; sarcasm drops the paired pop, so the read would see the
# redefined value (0xde). The pop's lost reload is rejected at the read.
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	endbr64
	subq	$64, %rsp
	movl	$111, %ebx
	pushq	%rbx
	movabsq	$0x4141414141414141, %rcx
	movq	%rcx, (%rsp)
	movl	$222, %ebx
	popq	%rbx
	movq	%rbx, %rax
	addq	$64, %rsp
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
