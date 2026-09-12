	.text
	# An indexed lea directly off a caller-set pseudo-register inside a
	# localcall clone behaves identically to the two-step idiom (copy the
	# pseudo through a register, then the register-index lea): same address,
	# same capability. The caller fills the `.alloca` buffer with 100..103;
	# the clone loads element i and adds the addend, so both forms must agree
	# exactly.
	.globl	leaidxc_single
	.type	leaidxc_single, @function
leaidxc_single:                 ;! long(long,long)
	endbr64
	.alloca $64, $16, %fil_raw
	leaq	16(%fil_raw), %fil_base
	movq	$100, (%fil_base)
	movq	$101, 8(%fil_base)
	movq	$102, 16(%fil_base)
	movq	$103, 24(%fil_base)
	movq	%rdi, %r11           # index survives into the clone in %r11
	movq	%rsi, %r12           # addend in %r12
	call	sub_single
	ret
	.size	leaidxc_single, .-leaidxc_single
	.type	sub_single, @function
sub_single:
	leaq	(%fil_base,%r11,8), %rax
	movq	(%rax), %rax
	addq	%r12, %rax
	ret
	.size	sub_single, .-sub_single
	.globl	leaidxc_two
	.type	leaidxc_two, @function
leaidxc_two:                    ;! long(long,long)
	endbr64
	.alloca $64, $16, %fil_raw
	leaq	16(%fil_raw), %fil_base
	movq	$100, (%fil_base)
	movq	$101, 8(%fil_base)
	movq	$102, 16(%fil_base)
	movq	$103, 24(%fil_base)
	movq	%rdi, %r11
	movq	%rsi, %r12
	call	sub_two
	ret
	.size	leaidxc_two, .-leaidxc_two
	.type	sub_two, @function
sub_two:
	movq	%fil_base, %rax
	leaq	(%rax,%r11,8), %rax
	movq	(%rax), %rax
	addq	%r12, %rax
	ret
	.size	sub_two, .-sub_two
	.globl	leaidxc_spill
	.type	leaidxc_spill, @function
	# Spill-derived base: the clone reloads the buffer pointer from a frame
	# slot, indexes with a single-step lea, and aligns down with `and $-16`
	# (in-clone `and` keeps the capability like everywhere else).
leaidxc_spill:                  ;! long(long,long)
	pushq	%rbp
	movq	%rsp, %rbp
	.alloca $64, $16, %fil_raw
	leaq	16(%fil_raw), %fil_base
	movq	$100, (%fil_base)
	movq	$101, 8(%fil_base)
	movq	$102, 16(%fil_base)
	movq	$103, 24(%fil_base)
	movq	%fil_base, -8(%rbp)
	movq	%rdi, %r11
	movq	%rsi, %r12
	call	sub_spill
	popq	%rbp
	ret
	.size	leaidxc_spill, .-leaidxc_spill
	.type	sub_spill, @function
sub_spill:
	movq	-8(%rbp), %rax
	leaq	(%rax,%r11,8), %rax
	movq	(%rax), %rax
	andq	$-16, %rax
	addq	%r12, %rax
	ret
	.size	sub_spill, .-sub_spill
	.section	.note.GNU-stack,"",@progbits
