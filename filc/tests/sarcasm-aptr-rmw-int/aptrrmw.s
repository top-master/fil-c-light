	.intel_syntax noprefix
	.text
	.globl	lsp_add
	.type	lsp_add, @function
lsp_add:                        ;! ptr(ptr, long)
	# non-atomic RMW on a pointer slot: box-aware pointer load, add on the
	# intval, non-atomic pointer store (capability preserved). Returns the
	# NEW pointer.
	add	QWORD PTR [rdi], rsi    ;! load store ptr
	mov	rax, QWORD PTR [rdi]    ;! load ptr
	ret
	.size	lsp_add, .-lsp_add
	.globl	lsp_sub
	.type	lsp_sub, @function
lsp_sub:                        ;! ptr(ptr, long)
	sub	QWORD PTR [rdi], rsi    ;! load store ptr
	mov	rax, QWORD PTR [rdi]    ;! load ptr
	ret
	.size	lsp_sub, .-lsp_sub
	.globl	lsp_inc
	.type	lsp_inc, @function
lsp_inc:                        ;! ptr(ptr)
	inc	QWORD PTR [rdi]         ;! load store ptr
	mov	rax, QWORD PTR [rdi]    ;! load ptr
	ret
	.size	lsp_inc, .-lsp_inc
	.globl	lsp_dec
	.type	lsp_dec, @function
lsp_dec:                        ;! ptr(ptr)
	dec	QWORD PTR [rdi]         ;! load store ptr
	mov	rax, QWORD PTR [rdi]    ;! load ptr
	ret
	.size	lsp_dec, .-lsp_dec
	.globl	lsp_xor
	.type	lsp_xor, @function
lsp_xor:                        ;! long(ptr, long)
	# flags consumer immediately after: sete reads the RMW's ZF natively
	xor	QWORD PTR [rdi], rsi    ;! load store ptr
	sete	al
	movzx	eax, al
	ret
	.size	lsp_xor, .-lsp_xor
	.globl	lsp_add_cf
	.type	lsp_add_cf, @function
lsp_add_cf:                     ;! long(ptr, long)
	# flags consumer immediately after: setc reads the RMW's CF natively
	add	QWORD PTR [rdi], rsi    ;! load store ptr
	setc	al
	movzx	eax, al
	ret
	.size	lsp_add_cf, .-lsp_add_cf
	.globl	lsp_add_jc
	.type	lsp_add_jc, @function
lsp_add_jc:                     ;! long(ptr, long)
	# a BRANCH flag consumer immediately after: jc reads the RMW's CF natively
	add	QWORD PTR [rdi], rsi    ;! load store ptr
	jc	.Lcarry
	mov	eax, 0
	ret
.Lcarry:
	mov	eax, 1
	ret
	.size	lsp_add_jc, .-lsp_add_jc
	.globl	lsp_or
	.type	lsp_or, @function
lsp_or:                         ;! ptr(ptr, long)
	or	QWORD PTR [rdi], rsi    ;! load store ptr
	mov	rax, QWORD PTR [rdi]    ;! load ptr
	ret
	.size	lsp_or, .-lsp_or
	.globl	lsp_and
	.type	lsp_and, @function
lsp_and:                        ;! ptr(ptr, long)
	and	QWORD PTR [rdi], rsi    ;! load store ptr
	mov	rax, QWORD PTR [rdi]    ;! load ptr
	ret
	.size	lsp_and, .-lsp_and
	.globl	lsp_neg
	.type	lsp_neg, @function
lsp_neg:                        ;! ptr(ptr)
	# unary RMW: iv = -iv, capability preserved (neg(neg(x)) == x)
	neg	QWORD PTR [rdi]         ;! load store ptr
	mov	rax, QWORD PTR [rdi]    ;! load ptr
	ret
	.size	lsp_neg, .-lsp_neg
	.globl	lsp_not
	.type	lsp_not, @function
lsp_not:                        ;! ptr(ptr)
	# unary RMW: iv = ~iv, capability preserved (not(not(x)) == x)
	not	QWORD PTR [rdi]         ;! load store ptr
	mov	rax, QWORD PTR [rdi]    ;! load ptr
	ret
	.size	lsp_not, .-lsp_not
	.globl	lsp_deref
	.type	lsp_deref, @function
lsp_deref:                      ;! int(ptr)
	# load the slot's pointer (after a prior RMW) and dereference it
	mov	rax, QWORD PTR [rdi]    ;! load ptr
	movzx	eax, BYTE PTR [rax]
	ret
	.size	lsp_deref, .-lsp_deref
	.section	.note.GNU-stack,"",@progbits
