	.intel_syntax noprefix
	.text
	.globl	fpo1
	.type	fpo1, @function
fpo1:                           ;! long(long)
	endbr64
	push	rbx
	mov	rbx, rsp          # the prologue parks rsp in rbx (a callee-saved register)
	sub	rsp, 16
	mov	QWORD PTR [rsp], rdi   # rsp-relative slot traffic at the post-prologue depth
	mov	rax, QWORD PTR [rsp]
	add	rax, 5
	mov	QWORD PTR [rsp+8], rax
	mov	rax, QWORD PTR [rsp+8]
	mov	rsp, rbx          # recover rsp from the prologue save (dropped)
	pop	rbx               # pairs with the prologue push (dropped)
	ret
	.size	fpo1, .-fpo1
	.globl	fpo2
	.type	fpo2, @function
fpo2:                           ;! long(long)
	endbr64
	push	r12
	mov	r12, rsp          # a second save register; TWO recoveries from it
	sub	rsp, 16
	mov	QWORD PTR [rsp], rdi
	mov	rax, QWORD PTR [rsp]
	add	rax, 5
	mov	QWORD PTR [rsp+8], rax
	mov	rax, QWORD PTR [rsp+8]
	mov	rsp, r12          # recovery #1 (the register still holds the save)
	mov	rsp, r12          # recovery #2 - still valid: the recovery leaves it alone
	pop	r12               # pairs with the prologue push
	ret
	.size	fpo2, .-fpo2
	.globl	fpo3
	.type	fpo3, @function
fpo3:                           ;! long(long)
	endbr64
	push	rbp
	mov	rbp, rsp
	push	rbx
	mov	rbx, rsp          # the rsp save; rbx is also a pushed callee-saved register
	sub	rsp, 16
	mov	QWORD PTR [rbp-16], rdi   # rbp-relative slot traffic
	mov	rsp, rbx          # recover rsp from the save...
	mov	rax, QWORD PTR [rbp-16]   # ...and keep doing rbp-relative traffic: rbp is static
	add	rax, 1
	pop	rbx               # pairs with the pushed save
	pop	rbp               # pairs with the saved frame pointer
	ret
	.size	fpo3, .-fpo3
	.globl	fpo4
	.type	fpo4, @function
fpo4:                           ;! long(long)
	endbr64
	push	rbx
	mov	rbx, rsp
	sub	rsp, 24
	mov	QWORD PTR [rsp], rdi
	mov	rax, QWORD PTR [rsp]
	add	rax, 5
	mov	rsp, rbx          # recover rsp from the save...
	add	rsp, 8            # ...then a constant teardown that discards the pushed rbx
	ret
	.size	fpo4, .-fpo4
	.section	.note.GNU-stack,"",@progbits
