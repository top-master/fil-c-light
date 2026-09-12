	.intel_syntax noprefix
	.text
	.globl	x87_misc
	.type	x87_misc, @function
x87_misc:                       ;! long(long)
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	fild	QWORD PTR [rbp-8]
	fldz
	fxch	st(1)
	fucom	st(1)
	fnstsw	ax
	movzx	ecx, ax
	fstp	st(0)
	fstp	st(0)
	test	ecx, 256
	jne	.Lmisc_less
	test	ecx, 16384
	jne	.Lmisc_eq
	mov	eax, 1
	jmp	.Lmisc_out
.Lmisc_less:
	mov	rax, -1
	jmp	.Lmisc_out
.Lmisc_eq:
	xor	eax, eax
.Lmisc_out:
	leave
	ret
	.size	x87_misc, .-x87_misc
	.globl	x87_cmp1
	.type	x87_cmp1, @function
x87_cmp1:                       ;! long(long)
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	fild	QWORD PTR [rbp-8]
	fld1
	fcom	st(1)
	fnstsw	ax
	movzx	ecx, ax
	fstp	st(0)
	fstp	st(0)
	test	ecx, 256
	jne	.Lcmp1_less
	test	ecx, 16384
	jne	.Lcmp1_eq
	mov	eax, 1
	jmp	.Lcmp1_out
.Lcmp1_less:
	mov	rax, -1
	jmp	.Lcmp1_out
.Lcmp1_eq:
	xor	eax, eax
.Lcmp1_out:
	leave
	ret
	.size	x87_cmp1, .-x87_cmp1
	.section	.note.GNU-stack,"",@progbits
