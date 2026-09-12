# Intel-syntax twin of sarcasm-midsp-pair-att: balanced mid-function
# `sub rsp, 64` / `add rsp, 64` and `lea rsp, [rsp-96]` / `lea rsp, [rsp+96]`
# inner-frame pairs with scratch traffic at both levels. f(a, b) = 3*(a + b).
	.intel_syntax noprefix
	.file	"midsp_pair.c"
	.text
	.globl	midsp_pair
	.type	midsp_pair, @function
midsp_pair:                     ;! long(long, long)
	push	rbx
	push	r12
	sub	rsp, 32
	mov	QWORD PTR [rsp], rdi      # outer[0] = a
	mov	QWORD PTR [rsp+8], rsi    # outer[8] = b
	# inner frame 1: sub/add pair at depth 48 -> 112
	sub	rsp, 64
	mov	rax, QWORD PTR [rsp+64]   # outer[0] from inside the inner frame
	mov	QWORD PTR [rsp], rax      # inner1[0] = a
	mov	rax, QWORD PTR [rsp+72]   # outer[8]
	mov	QWORD PTR [rsp+8], rax    # inner1[8] = b
	mov	rax, QWORD PTR [rsp]
	add	rax, QWORD PTR [rsp+8]    # a + b
	mov	rbx, rax
	add	rsp, 64                   # back to depth 48
	# inner frame 2: lea pair at depth 48 -> 144
	lea	rsp, [rsp-96]
	mov	r12, QWORD PTR [rsp+96]   # outer[0]
	mov	QWORD PTR [rsp], r12      # inner2[0] = a
	mov	rax, QWORD PTR [rsp+104]  # outer[8]
	mov	QWORD PTR [rsp+8], rax    # inner2[8] = b
	mov	rax, QWORD PTR [rsp]
	add	rax, QWORD PTR [rsp+8]    # a + b
	mov	r12, rax
	lea	rsp, [rsp+96]             # back to depth 48
	# outer level: a + b again, then combine
	mov	rax, QWORD PTR [rsp]
	add	rax, QWORD PTR [rsp+8]
	add	rax, rbx
	add	rax, r12                  # 3*(a + b)
	add	rsp, 32
	pop	r12
	pop	rbx
	ret
	.size	midsp_pair, .-midsp_pair
	.section	.note.GNU-stack,"",@progbits
