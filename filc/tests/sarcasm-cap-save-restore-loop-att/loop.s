	.text
	# A save outside a loop dominating a restore inside it: every path from
	# entry to the restore executes the save (the loop head is only reachable
	# through the save).
	.globl	cap_loop
	.type	cap_loop, @function
cap_loop:                       ;! long(ptr, long)
	endbr64
	movq	%rdi, %rax  #! save capability (slot)
	movq	%rsi, %rcx
.Lloop:
	movq	(%rax), %rax
	addq	$0, %rax  #! restore capability (slot)
	movq	(%rax), %rax
	subq	$1, %rcx
	jne	.Lloop
	ret
	.size	cap_loop, .-cap_loop
	.section	.note.GNU-stack,"",@progbits
