	.text
	.globl	flagsahf
	.type	flagsahf, @function
flagsahf:                       ;! long(ptr)
	stc
	lahf
	movq	(%rdi), %rcx
	sahf
	jc	.Lcarry
	movl	$0, %eax
	ret
.Lcarry:
	movl	$1, %eax
	ret
	.size	flagsahf, .-flagsahf
	.section	.note.GNU-stack,"",@progbits
