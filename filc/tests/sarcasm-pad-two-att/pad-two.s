# A two-register transient prologue pad: the first push (rbx) sits at the
# HIGHER address, so (%rsp) aliases the second push's (rbp) save slot and
# 8(%rsp) aliases the first push's. Each store must update the matching
# register's web (first push = higher address); 16(%rsp) is a plain frame slot
# and must stay one. Both save-slot stores used to miscompile silently (the
# dropped pops resurrected the stale pre-push values).
	.text
	.globl	pad_two
	.type	pad_two, @function
pad_two:                        ;! long(ptr)
	endbr64
	movq	%rdi, %rax
	subq	$64, %rsp
	movl	$111, %ebx
	movl	$222, %ebp
	pushq	%rbx
	pushq	%rbp
	movabsq	$0x1111111111111111, %rcx
	movq	%rcx, (%rsp)
	movabsq	$0x2222222222222222, %rcx
	movq	%rcx, 8(%rsp)
	movabsq	$0x3333333333333333, %rcx
	movq	%rcx, 16(%rsp)
	popq	%rbp
	popq	%rbx
	addq	%rbx, %rax
	addq	%rbp, %rax
	addq	$64, %rsp
	ret
	.size	pad_two, .-pad_two
	.section	.note.GNU-stack,"",@progbits
