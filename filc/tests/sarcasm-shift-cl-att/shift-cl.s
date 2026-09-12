# Register-count shifts/rotates (`shlq %cl, %rdx` & co): the count register is
# ALWAYS %cl — the only register-count encoding in the ISA. The count's web is
# pinned to physical rcx; left renameable, regalloc colored it anywhere and the
# emitted `shlq %sil, %rdx` failed to assemble (the aes-cfb-avx512 miscompile).
# Exercised here with the count flowing through several webs, and a second
# value kept live in rcx's low byte across the shift.
	.text
	.globl	shift_cl_ops
	.type	shift_cl_ops, @function
shift_cl_ops:                   ;! void(ptr)
	endbr64
	movq	(%rdi), %rax
	movl	8(%rdi), %ecx
	# shift by a count loaded into rcx
	shlq	%cl, %rax
	movq	%rax, (%rdi)
	# the count computed into another register first (web flows into %cl)
	movl	12(%rdi), %edx
	addl	$3, %edx
	movl	%edx, %ecx
	movq	16(%rdi), %rax
	shrq	%cl, %rax
	movq	%rax, 16(%rdi)
	# rotate by %cl, and sar
	movl	$8, %ecx
	movq	24(%rdi), %rax
	rorq	%cl, %rax
	movq	%rax, 24(%rdi)
	movq	32(%rdi), %rax
	sarq	%cl, %rax
	movq	%rax, 32(%rdi)
	# shl with count in cl while another value lives in the SAME web's other
	# bytes (rcx as an ordinary value before and after)
	movq	$0xDEADBEEF00, %rcx
	movl	40(%rdi), %ecx
	movq	48(%rdi), %rdx
	shlq	%cl, %rdx
	movq	%rdx, 48(%rdi)
	# under pressure
	movq	$0x1111111111111111, %r12
	movq	$0x2222222222222222, %r13
	movq	%r12, 56(%rdi)
	movq	%r13, 64(%rdi)
	ret
	.size	shift_cl_ops, .-shift_cl_ops
	.section	.note.GNU-stack,"",@progbits
