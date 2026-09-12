# B2 mid-body join with a FRAME RESHAPE (the ecp_nistz256_point_add shape):
# the jumper has a larger frame than the tail's owner; it does `addq $K,%rsp`
# to reshape into the owner's frame before jumping, so the clone's slot
# accesses key into the jumper's frame at the matching depth.
	.text
	.globl	big_frame
	.type	big_frame, @function
big_frame:                      ;! long(long,long,long)
	pushq	%rbp
	pushq	%rbx
	pushq	%r12
	pushq	%r13
	pushq	%r14
	pushq	%r15
	subq	$104, %rsp              # frame depth 152 (48 + 104)
	movq	%rdi, %rbx
	addq	%rsi, %rbx              # rbx = a + b (shared register state)
	movq	%rbx, 96(%rsp)          # use the deep slots (keeps them live)
	movq	%rdi, 88(%rsp)
	testl	%edx, %edx
	jnz	.Lkeep_going
	addq	$64, %rsp               # reshape into small_frame's depth (88)
	jmp	.Lsmall_tail
.Lkeep_going:
	movq	96(%rsp), %rax          # deep-frame result: rbx + 96-slot + 88-slot
	addq	88(%rsp), %rax
	addq	$104, %rsp
	popq	%r15
	popq	%r14
	popq	%r13
	popq	%r12
	popq	%rbx
	popq	%rbp
	ret
	.size	big_frame, .-big_frame
	.globl	small_frame
	.type	small_frame, @function
small_frame:                    ;! long(long)
	pushq	%rbp
	pushq	%rbx
	pushq	%r12
	pushq	%r13
	pushq	%r14
	pushq	%r15
	subq	$40, %rsp               # frame depth 88 (48 + 40)
	movq	%rdi, %rbx
	imulq	$3, %rbx                # rbx = 3*a
	nop
.Lsmall_tail:
	# the shared tail: rbx * 2 + 5, returned (slots are the owner's locals)
	movq	%rbx, 0(%rsp)
	movq	0(%rsp), %rax
	addq	%rbx, %rax
	addq	$5, %rax
	addq	$40, %rsp
	popq	%r15
	popq	%r14
	popq	%r13
	popq	%r12
	popq	%rbx
	popq	%rbp
	ret
	.size	small_frame, .-small_frame
	.section	.note.GNU-stack,"",@progbits
