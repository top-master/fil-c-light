	.intel_syntax noprefix
	.text
	.globl	asf
	.type	asf, @function
asf:                            ;! ptr(long)
	endbr64
	push	rbp
	mov	rbp, rsp
	push	rbx
	mov	rbx, rsp          # the prologue parks rsp in rbx (a callee-saved register)
	sub	rsp, 24
	mov	rax, rdi          ;! alloca size (s)
	mov	QWORD PTR [rbp-24], rax   # spill the size through an rbp-relative slot
	lea	rcx, [rax+23]
	and	rcx, -16
	sub	rsp, rcx          # the dynamic allocation: the depth becomes unknown...
	lea	rdx, [rsp+15]
	mov	rdi, rdx
	and	rdi, -16          ;! alloca result (s)
	mov	QWORD PTR [rbp-16], rdi   # ...but rbp-relative traffic still works through it
	mov	rsi, QWORD PTR [rbp-24]   # n
	mov	rdx, QWORD PTR [rbp-16]   # buffer
	xor	ecx, ecx
	test	rsi, rsi
	jle	.Ldone
.Lfill:
	mov	BYTE PTR [rdx+rcx], cl
	inc	rcx
	cmp	rcx, rsi
	jne	.Lfill
.Ldone:
	mov	rsp, rbx          # recover rsp from the prologue save: revives a KNOWN depth
	mov	rax, QWORD PTR [rbp-16]   # rbp-relative traffic AFTER the recovery (rbp is static)
	pop	rbx               # pairs with the prologue push of rbx
	pop	rbp               # pairs with the saved frame pointer
	ret
	.size	asf, .-asf
	.section	.note.GNU-stack,"",@progbits
