	.text
	.globl	x87_misc
	.type	x87_misc, @function
x87_misc:                       ;! long(long)
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	fildq	-8(%rbp)
	fldz
	fxch	%st(1)
	fucom	%st(1)
	fnstsw	%ax
	movzwl	%ax, %ecx
	fstp	%st(0)
	fstp	%st(0)
	testl	$256, %ecx
	jne	.Lmisc_less
	testl	$16384, %ecx
	jne	.Lmisc_eq
	movl	$1, %eax
	jmp	.Lmisc_out
.Lmisc_less:
	movq	$-1, %rax
	jmp	.Lmisc_out
.Lmisc_eq:
	xorl	%eax, %eax
.Lmisc_out:
	leave
	ret
	.size	x87_misc, .-x87_misc
	.globl	x87_cmp1
	.type	x87_cmp1, @function
x87_cmp1:                       ;! long(long)
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	fildq	-8(%rbp)
	fld1
	fcom	%st(1)
	fnstsw	%ax
	movzwl	%ax, %ecx
	fstp	%st(0)
	fstp	%st(0)
	testl	$256, %ecx
	jne	.Lcmp1_less
	testl	$16384, %ecx
	jne	.Lcmp1_eq
	movl	$1, %eax
	jmp	.Lcmp1_out
.Lcmp1_less:
	movq	$-1, %rax
	jmp	.Lcmp1_out
.Lcmp1_eq:
	xorl	%eax, %eax
.Lcmp1_out:
	leave
	ret
	.size	x87_cmp1, .-x87_cmp1
	.section	.note.GNU-stack,"",@progbits
