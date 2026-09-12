	.intel_syntax noprefix
	.text
	.globl	sc_eq_one
	.type	sc_eq_one, @function
sc_eq_one:                      ;! long()
	# A register-destination setcc is MODELED as a full-width (64-bit) def of
	# its destination web but the hardware writes only the low byte; sarcasm
	# makes the hardware match by emitting the zero-extension after it. Every
	# function here fills every allocatable GPR (all but rdi, the myth
	# register, and r11, the glue scratch) with 0x7777777777777777, so the
	# physical register the setcc destination web is colored into holds
	# garbage in its upper 56 bits at the setcc. Reading the destination web
	# back WIDER than 8 bits (mov rax, rbx) must see exactly 0/1 — before
	# the widening it saw 0x7777777777777700/01.
	# ZF is SET here (0x7777... == itself), so the correct result is 1.
	endbr64
	movabs	rax, 0x7777777777777777
	movabs	rcx, 0x7777777777777777
	movabs	rdx, 0x7777777777777777
	movabs	rbx, 0x7777777777777777
	movabs	rbp, 0x7777777777777777
	movabs	rsi, 0x7777777777777777
	movabs	r8, 0x7777777777777777
	movabs	r9, 0x7777777777777777
	movabs	r10, 0x7777777777777777
	movabs	r12, 0x7777777777777777
	movabs	r13, 0x7777777777777777
	movabs	r14, 0x7777777777777777
	movabs	r15, 0x7777777777777777
	cmp	rax, rax
	sete	bl
	mov	rax, rbx        # read the destination web WIDER than 8 bits
	ret
	.size	sc_eq_one, .-sc_eq_one

	.globl	sc_eq_zero
	.type	sc_eq_zero, @function
sc_eq_zero:                     ;! long()
	# ZF is CLEAR (0x7777... != 5), so the correct result is 0: a pre-widening
	# read exposed 0x7777777777777700 instead.
	endbr64
	movabs	rax, 0x7777777777777777
	movabs	rcx, 0x7777777777777777
	movabs	rdx, 0x7777777777777777
	movabs	rbx, 0x7777777777777777
	movabs	rbp, 0x7777777777777777
	movabs	rsi, 0x7777777777777777
	movabs	r8, 0x7777777777777777
	movabs	r9, 0x7777777777777777
	movabs	r10, 0x7777777777777777
	movabs	r12, 0x7777777777777777
	movabs	r13, 0x7777777777777777
	movabs	r14, 0x7777777777777777
	movabs	r15, 0x7777777777777777
	cmp	rax, 5
	sete	bl
	mov	rax, rbx        # read the destination web WIDER than 8 bits
	ret
	.size	sc_eq_zero, .-sc_eq_zero

	.globl	sc_ne_one
	.type	sc_ne_one, @function
sc_ne_one:                      ;! long()
	# setne of a clear ZF: the correct result is 1.
	endbr64
	movabs	rax, 0x7777777777777777
	movabs	rcx, 0x7777777777777777
	movabs	rdx, 0x7777777777777777
	movabs	rbx, 0x7777777777777777
	movabs	rbp, 0x7777777777777777
	movabs	rsi, 0x7777777777777777
	movabs	r8, 0x7777777777777777
	movabs	r9, 0x7777777777777777
	movabs	r10, 0x7777777777777777
	movabs	r12, 0x7777777777777777
	movabs	r13, 0x7777777777777777
	movabs	r14, 0x7777777777777777
	movabs	r15, 0x7777777777777777
	cmp	rax, 5
	setne	bl
	mov	rax, rbx        # read the destination web WIDER than 8 bits
	ret
	.size	sc_ne_one, .-sc_ne_one

	.globl	sc_lt_zero
	.type	sc_lt_zero, @function
sc_lt_zero:                     ;! long()
	# signed setl of 0x7777... - 5 (positive, no overflow): the correct result
	# is 0; a pre-widening read exposed 0x7777777777777700 instead.
	endbr64
	movabs	rax, 0x7777777777777777
	movabs	rcx, 0x7777777777777777
	movabs	rdx, 0x7777777777777777
	movabs	rbx, 0x7777777777777777
	movabs	rbp, 0x7777777777777777
	movabs	rsi, 0x7777777777777777
	movabs	r8, 0x7777777777777777
	movabs	r9, 0x7777777777777777
	movabs	r10, 0x7777777777777777
	movabs	r12, 0x7777777777777777
	movabs	r13, 0x7777777777777777
	movabs	r14, 0x7777777777777777
	movabs	r15, 0x7777777777777777
	cmp	rax, 5
	setl	bl
	mov	rax, rbx        # read the destination web WIDER than 8 bits
	ret
	.size	sc_lt_zero, .-sc_lt_zero

	.globl	sc_gt_one
	.type	sc_gt_one, @function
sc_gt_one:                      ;! long()
	# signed setg of 0x7777... - 5 (positive, no overflow): the correct result
	# is 1.
	endbr64
	movabs	rax, 0x7777777777777777
	movabs	rcx, 0x7777777777777777
	movabs	rdx, 0x7777777777777777
	movabs	rbx, 0x7777777777777777
	movabs	rbp, 0x7777777777777777
	movabs	rsi, 0x7777777777777777
	movabs	r8, 0x7777777777777777
	movabs	r9, 0x7777777777777777
	movabs	r10, 0x7777777777777777
	movabs	r12, 0x7777777777777777
	movabs	r13, 0x7777777777777777
	movabs	r14, 0x7777777777777777
	movabs	r15, 0x7777777777777777
	cmp	rax, 5
	setg	bl
	mov	rax, rbx        # read the destination web WIDER than 8 bits
	ret
	.size	sc_gt_one, .-sc_gt_one

	.globl	sc_byte_one
	.type	sc_byte_one, @function
sc_byte_one:                    ;! long()
	# The 8-bit read-back idiom (setcc + manual movzx) that every pre-existing
	# setcc test writes by hand: it must keep working next to the widening
	# (the second movzx is redundant, not harmful).
	endbr64
	movabs	rax, 0x7777777777777777
	movabs	rcx, 0x7777777777777777
	movabs	rdx, 0x7777777777777777
	movabs	rbx, 0x7777777777777777
	movabs	rbp, 0x7777777777777777
	movabs	rsi, 0x7777777777777777
	movabs	r8, 0x7777777777777777
	movabs	r9, 0x7777777777777777
	movabs	r10, 0x7777777777777777
	movabs	r12, 0x7777777777777777
	movabs	r13, 0x7777777777777777
	movabs	r14, 0x7777777777777777
	movabs	r15, 0x7777777777777777
	cmp	rax, rax
	sete	al
	movzx	eax, al
	ret
	.size	sc_byte_one, .-sc_byte_one

	.globl	sc_arg
	.type	sc_arg, @function
sc_arg:                         ;! long(long)
	# An argument-using variant: the asm-visible first argument register is
	# rdi (sarcasm copies the fast-CC dense argument register into it before
	# the body). sete on the comparison against 42, destination web read back
	# through the full 64 bits of rbx. rax keeps the argument, so it is not
	# poisoned here.
	endbr64
	mov	rax, rdi
	movabs	rcx, 0x7777777777777777
	movabs	rdx, 0x7777777777777777
	movabs	rbx, 0x7777777777777777
	movabs	rbp, 0x7777777777777777
	movabs	rsi, 0x7777777777777777
	movabs	r8, 0x7777777777777777
	movabs	r9, 0x7777777777777777
	movabs	r10, 0x7777777777777777
	movabs	r12, 0x7777777777777777
	movabs	r13, 0x7777777777777777
	movabs	r14, 0x7777777777777777
	movabs	r15, 0x7777777777777777
	cmp	rax, 42
	sete	bl
	mov	rax, rbx        # read the destination web WIDER than 8 bits
	ret
	.size	sc_arg, .-sc_arg
	.section	.note.GNU-stack,"",@progbits
