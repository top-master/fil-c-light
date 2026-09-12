# Intel-syntax twin of the sha256 frame shape (see the -att test).
	.intel_syntax noprefix
	.text
	.globl	buf96
	.type	buf96, @function
buf96:                          ;! void(ptr,ptr)
	mov	rax, rsp            # park rsp in a CALLER-SAVED register
	push	rbx
	sub	rsp, 64+32
	and	rsp, -64            ;! alloca result size=96
	mov	QWORD PTR [rsp+64+0], rdi  ;! store ptr
	mov	QWORD PTR [rsp+64+8], rsi  ;! store ptr
	mov	QWORD PTR [rsp+88], rax      # save-store
	mov	rdi, QWORD PTR [rsp+64+0]  ;! load ptr
	mov	rsi, QWORD PTR [rsp+64+8]  ;! load ptr
	mov	rcx, QWORD PTR [rsi]
	add	rcx, 1
	mov	QWORD PTR [rsp], rcx
	mov	rcx, QWORD PTR [rsi+8]
	add	rcx, 1
	mov	QWORD PTR [rsp+8], rcx
	mov	rcx, QWORD PTR [rsi+16]
	add	rcx, 1
	mov	QWORD PTR [rsp+16], rcx
	mov	rcx, QWORD PTR [rsi+24]
	add	rcx, 1
	mov	QWORD PTR [rsp+24], rcx
	movdqa	xmm0, XMMWORD PTR [rsi+32]
	movdqa	XMMWORD PTR [rsp+32], xmm0
	movdqa	xmm1, XMMWORD PTR [rsi+48]
	movdqa	XMMWORD PTR [rsp+48], xmm1
	mov	rcx, QWORD PTR [rsp]
	mov	QWORD PTR [rdi], rcx
	mov	rcx, QWORD PTR [rsp+8]
	mov	QWORD PTR [rdi+8], rcx
	mov	rcx, QWORD PTR [rsp+16]
	mov	QWORD PTR [rdi+16], rcx
	mov	rcx, QWORD PTR [rsp+24]
	mov	QWORD PTR [rdi+24], rcx
	movdqa	xmm2, XMMWORD PTR [rsp+32]
	movdqa	XMMWORD PTR [rdi+32], xmm2
	movdqa	xmm3, XMMWORD PTR [rsp+48]
	movdqa	XMMWORD PTR [rdi+48], xmm3
	mov	rsi, QWORD PTR [rsp+88]      # reload the saved rsp (carrier-load)
	mov	rbx, QWORD PTR [rsi-8]       # restore rbx through it
	lea	rsp, [rsi]                   # recover rsp (phantom)
	ret
	.size	buf96, .-buf96
	.section	.note.GNU-stack,"",@progbits
