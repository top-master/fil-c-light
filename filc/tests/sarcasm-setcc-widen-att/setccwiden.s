	.text
	.globl	sc_eq_one
	.type	sc_eq_one, @function
sc_eq_one:                      ;! long()
	# A register-destination setcc is MODELED as a full-width (64-bit) def of
	# its destination web but the hardware writes only the low byte; sarcasm
	# makes the hardware match by emitting the zero-extension after it. Every
	# function here fills every allocatable GPR (all but %rdi, the myth
	# register, and %r11, the glue scratch) with 0x7777777777777777, so the
	# physical register the setcc destination web is colored into holds
	# garbage in its upper 56 bits at the setcc. Reading the destination web
	# back WIDER than 8 bits (movq %rbx, %rax) must see exactly 0/1 — before
	# the widening it saw 0x7777777777777700/01.
	# ZF is SET here (0x7777... == itself), so the correct result is 1.
	endbr64
	movq	$0x7777777777777777, %rax
	movq	$0x7777777777777777, %rcx
	movq	$0x7777777777777777, %rdx
	movq	$0x7777777777777777, %rbx
	movq	$0x7777777777777777, %rbp
	movq	$0x7777777777777777, %rsi
	movq	$0x7777777777777777, %r8
	movq	$0x7777777777777777, %r9
	movq	$0x7777777777777777, %r10
	movq	$0x7777777777777777, %r12
	movq	$0x7777777777777777, %r13
	movq	$0x7777777777777777, %r14
	movq	$0x7777777777777777, %r15
	cmpq	%rax, %rax
	sete	%bl
	movq	%rbx, %rax      # read the destination web WIDER than 8 bits
	retq
	.size	sc_eq_one, .-sc_eq_one

	.globl	sc_eq_zero
	.type	sc_eq_zero, @function
sc_eq_zero:                     ;! long()
	# ZF is CLEAR (0x7777... != 5), so the correct result is 0: a pre-widening
	# read exposed 0x7777777777777700 instead.
	endbr64
	movq	$0x7777777777777777, %rax
	movq	$0x7777777777777777, %rcx
	movq	$0x7777777777777777, %rdx
	movq	$0x7777777777777777, %rbx
	movq	$0x7777777777777777, %rbp
	movq	$0x7777777777777777, %rsi
	movq	$0x7777777777777777, %r8
	movq	$0x7777777777777777, %r9
	movq	$0x7777777777777777, %r10
	movq	$0x7777777777777777, %r12
	movq	$0x7777777777777777, %r13
	movq	$0x7777777777777777, %r14
	movq	$0x7777777777777777, %r15
	cmpq	$5, %rax
	sete	%bl
	movq	%rbx, %rax      # read the destination web WIDER than 8 bits
	retq
	.size	sc_eq_zero, .-sc_eq_zero

	.globl	sc_ne_one
	.type	sc_ne_one, @function
sc_ne_one:                      ;! long()
	# setne of a clear ZF: the correct result is 1.
	endbr64
	movq	$0x7777777777777777, %rax
	movq	$0x7777777777777777, %rcx
	movq	$0x7777777777777777, %rdx
	movq	$0x7777777777777777, %rbx
	movq	$0x7777777777777777, %rbp
	movq	$0x7777777777777777, %rsi
	movq	$0x7777777777777777, %r8
	movq	$0x7777777777777777, %r9
	movq	$0x7777777777777777, %r10
	movq	$0x7777777777777777, %r12
	movq	$0x7777777777777777, %r13
	movq	$0x7777777777777777, %r14
	movq	$0x7777777777777777, %r15
	cmpq	$5, %rax
	setne	%bl
	movq	%rbx, %rax      # read the destination web WIDER than 8 bits
	retq
	.size	sc_ne_one, .-sc_ne_one

	.globl	sc_lt_zero
	.type	sc_lt_zero, @function
sc_lt_zero:                     ;! long()
	# signed setl of 0x7777... - 5 (positive, no overflow): the correct result
	# is 0; a pre-widening read exposed 0x7777777777777700 instead.
	endbr64
	movq	$0x7777777777777777, %rax
	movq	$0x7777777777777777, %rcx
	movq	$0x7777777777777777, %rdx
	movq	$0x7777777777777777, %rbx
	movq	$0x7777777777777777, %rbp
	movq	$0x7777777777777777, %rsi
	movq	$0x7777777777777777, %r8
	movq	$0x7777777777777777, %r9
	movq	$0x7777777777777777, %r10
	movq	$0x7777777777777777, %r12
	movq	$0x7777777777777777, %r13
	movq	$0x7777777777777777, %r14
	movq	$0x7777777777777777, %r15
	cmpq	$5, %rax
	setl	%bl
	movq	%rbx, %rax      # read the destination web WIDER than 8 bits
	retq
	.size	sc_lt_zero, .-sc_lt_zero

	.globl	sc_gt_one
	.type	sc_gt_one, @function
sc_gt_one:                      ;! long()
	# signed setg of 0x7777... - 5 (positive, no overflow): the correct result
	# is 1.
	endbr64
	movq	$0x7777777777777777, %rax
	movq	$0x7777777777777777, %rcx
	movq	$0x7777777777777777, %rdx
	movq	$0x7777777777777777, %rbx
	movq	$0x7777777777777777, %rbp
	movq	$0x7777777777777777, %rsi
	movq	$0x7777777777777777, %r8
	movq	$0x7777777777777777, %r9
	movq	$0x7777777777777777, %r10
	movq	$0x7777777777777777, %r12
	movq	$0x7777777777777777, %r13
	movq	$0x7777777777777777, %r14
	movq	$0x7777777777777777, %r15
	cmpq	$5, %rax
	setg	%bl
	movq	%rbx, %rax      # read the destination web WIDER than 8 bits
	retq
	.size	sc_gt_one, .-sc_gt_one

	.globl	sc_byte_one
	.type	sc_byte_one, @function
sc_byte_one:                    ;! long()
	# The 8-bit read-back idiom (setcc + manual movzbl) that every pre-existing
	# setcc test writes by hand: it must keep working next to the widening
	# (the second movzbl is redundant, not harmful).
	endbr64
	movq	$0x7777777777777777, %rax
	movq	$0x7777777777777777, %rcx
	movq	$0x7777777777777777, %rdx
	movq	$0x7777777777777777, %rbx
	movq	$0x7777777777777777, %rbp
	movq	$0x7777777777777777, %rsi
	movq	$0x7777777777777777, %r8
	movq	$0x7777777777777777, %r9
	movq	$0x7777777777777777, %r10
	movq	$0x7777777777777777, %r12
	movq	$0x7777777777777777, %r13
	movq	$0x7777777777777777, %r14
	movq	$0x7777777777777777, %r15
	cmpq	%rax, %rax
	sete	%al
	movzbl	%al, %eax
	retq
	.size	sc_byte_one, .-sc_byte_one

	.globl	sc_arg
	.type	sc_arg, @function
sc_arg:                         ;! long(long)
	# An argument-using variant: the asm-visible first argument register is
	# %rdi (sarcasm copies the fast-CC dense argument register into it before
	# the body). sete on the comparison against 42, destination web read back
	# through the full 64 bits of %rbx. %rax keeps the argument, so it is not
	# poisoned here.
	endbr64
	movq	%rdi, %rax
	movq	$0x7777777777777777, %rcx
	movq	$0x7777777777777777, %rdx
	movq	$0x7777777777777777, %rbx
	movq	$0x7777777777777777, %rbp
	movq	$0x7777777777777777, %rsi
	movq	$0x7777777777777777, %r8
	movq	$0x7777777777777777, %r9
	movq	$0x7777777777777777, %r10
	movq	$0x7777777777777777, %r12
	movq	$0x7777777777777777, %r13
	movq	$0x7777777777777777, %r14
	movq	$0x7777777777777777, %r15
	cmpq	$42, %rax
	sete	%bl
	movq	%rbx, %rax      # read the destination web WIDER than 8 bits
	retq
	.size	sc_arg, .-sc_arg
	.section	.note.GNU-stack,"",@progbits
