# Intel-syntax twin of sarcasm-alloca-recover-att: three branch-free dynamic-alloca
# functions whose %rsp recovery sits in the SAME straight-line region as the
# `;! alloca result` annotation -- no label separates them. rec recovers from the
# frame pointer (mov form), rec2 recovers from the frame pointer with only the frame
# pointer pushed, and rec3 recovers from the prologue rsp save parked in %rbx.
	.intel_syntax noprefix
	.text
	.globl	rec
	.type	rec, @function
rec:                            ;! long()
	endbr64
	push	rbp
	push	rbx
	mov	rbp, rsp
	sub	rsp, 24
	mov	eax, 96            ;! alloca size (b1)
	mov	rcx, rax           # the deferred-idiom size chain
	lea	rdx, [rcx+15]
	and	rdx, -16
	sub	rsp, rdx           # the dynamic allocation: the depth becomes unknown...
	lea	rsi, [rsp+15]
	mov	rdi, rsi
	and	rdi, -16           ;! alloca result (b1)
	mov	QWORD PTR [rbp-24], rdi   # ...but rbp-relative traffic still works through it
	mov	rax, QWORD PTR [rbp-24]
	mov	QWORD PTR [rax], 16909060  # bytes 04 03 02 01 (little-endian)
	movzx	edx, BYTE PTR [rax+1]      # 0x03
	movzx	esi, BYTE PTR [rax+2]      # 0x02
	add	rsi, rdx
	mov	rax, QWORD PTR [rbp-24]
	movzx	edx, BYTE PTR [rax+3]      # 0x01
	add	rsi, rdx
	mov	rax, rsi           # return 3 + 2 + 1 = 6
	mov	rsp, rbp           # recover %rsp from the frame pointer: NO label before this
	pop	rbx                # pairs with the prologue push of %rbx
	pop	rbp                # pairs with the saved frame pointer
	ret
	.size	rec, .-rec
	.globl	rec2
	.type	rec2, @function
rec2:                           ;! long()
	endbr64
	push	rbp
	mov	rbp, rsp
	sub	rsp, 24
	mov	eax, 64            ;! alloca size (b2)
	mov	rcx, rax
	lea	rdx, [rcx+15]
	and	rdx, -16
	sub	rsp, rdx
	lea	rsi, [rsp+15]
	mov	rdi, rsi
	and	rdi, -16           ;! alloca result (b2)
	mov	QWORD PTR [rbp-16], rdi
	mov	rax, QWORD PTR [rbp-16]
	mov	QWORD PTR [rax], 258       # bytes 02 01
	movzx	edx, BYTE PTR [rax]        # 0x02
	movzx	esi, BYTE PTR [rax+1]      # 0x01
	add	rsi, rdx
	mov	rax, rsi           # return 2 + 1 = 3
	mov	rsp, rbp           # recover %rsp from the frame pointer: NO label before this
	pop	rbp                # pairs with the saved frame pointer
	ret
	.size	rec2, .-rec2
	.globl	rec3
	.type	rec3, @function
rec3:                           ;! long()
	endbr64
	push	rbp
	mov	rbp, rsp
	push	rbx
	mov	rbx, rsp           # the prologue parks %rsp in %rbx (a callee-saved register)
	sub	rsp, 24
	mov	eax, 80            ;! alloca size (b3)
	mov	rcx, rax
	lea	rdx, [rcx+15]
	and	rdx, -16
	sub	rsp, rdx
	lea	rsi, [rsp+15]
	mov	rdi, rsi
	and	rdi, -16           ;! alloca result (b3)
	mov	QWORD PTR [rbp-16], rdi
	mov	rax, QWORD PTR [rbp-16]
	mov	QWORD PTR [rax], 67438087  # bytes 07 06 05 04
	movzx	edx, BYTE PTR [rax]        # 0x07
	movzx	esi, BYTE PTR [rax+1]      # 0x06
	add	rsi, rdx
	mov	rax, QWORD PTR [rbp-16]
	movzx	edx, BYTE PTR [rax+2]      # 0x05
	add	rsi, rdx
	mov	rax, rsi           # return 7 + 6 + 5 = 18
	mov	rsp, rbx           # recover %rsp from the prologue save: NO label before this
	pop	rbx                # pairs with the prologue push of %rbx
	pop	rbp                # pairs with the saved frame pointer
	ret
	.size	rec3, .-rec3
	.section	.note.GNU-stack,"",@progbits
