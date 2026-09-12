# Plain GPR scalar loads/stores need only hardware-required alignment (x86
# tolerates misaligned scalar access), exactly like Fil-C compiled code
# (FilPizlonator's needToCheckAlignment is false for integer types, so the
# access is checked with alignment 1). The AES perlasm input/output blocks
# are arbitrarily aligned, so movl/movw/movq at odd offsets must work.
	.text
	.globl	scalar_unaligned
	.type	scalar_unaligned, @function
scalar_unaligned:               ;! void(ptr)
	endbr64
	movl	1(%rdi), %eax
	addl	$1, %eax
	movl	%eax, 1(%rdi)
	movw	7(%rdi), %ax
	addw	$2, %ax
	movw	%ax, 7(%rdi)
	movq	9(%rdi), %rax
	addq	$3, %rax
	movq	%rax, 9(%rdi)
	ret
	.size	scalar_unaligned, .-scalar_unaligned
	.section	.note.GNU-stack,"",@progbits
