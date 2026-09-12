	.intel_syntax noprefix
	.text
	.globl	cas16_test
	.type	cas16_test, @function
cas16_test:                     ;! void(ptr, ptr)
	# rdi -> long args[16]: [0]=expected lo, [1]=expected hi, [2]=desired lo,
	# [3]=desired hi; out: [4]=old lo, [5]=old hi,
	# [6]=flag + [7]+[8]+[9] + desired-lo (rbx, preserved across the CAS).
	# rsi -> 16-byte aligned 16-byte buffer. The implicit rdx:rax (expected,
	# mismatch writeback) and rcx:rbx (desired) pairs are pinned through
	# emitPinned; the [7]/[8]/[9] webs stay live ACROSS the pin.
	mov	rax, QWORD PTR [rdi]
	mov	rdx, QWORD PTR 8[rdi]
	mov	rbx, QWORD PTR 16[rdi]
	mov	rcx, QWORD PTR 24[rdi]
	mov	r8, QWORD PTR 56[rdi]
	mov	r9, QWORD PTR 64[rdi]
	mov	r10, QWORD PTR 72[rdi]
	lock cmpxchg16b	XMMWORD PTR [rsi]
	# sete must IMMEDIATELY follow the CAS: sarcasm's injected bounds checks
	# (for the stores below) clobber EFLAGS (a documented sarcasm property).
	sete	cl
	mov	QWORD PTR 32[rdi], rax
	mov	QWORD PTR 40[rdi], rdx
	movzx	ecx, cl
	add	rcx, r8
	add	rcx, r9
	add	rcx, r10
	# (rbx read after the CAS: the hardware preserves it across the CAS
	# while it is also the implicit pinned desired-lo source)
	add	rcx, rbx
	mov	QWORD PTR 48[rdi], rcx
	ret
	.size	cas16_test, .-cas16_test

	.globl	cas16_ul_test
	.type	cas16_ul_test, @function
cas16_ul_test:                  ;! void(ptr, ptr)
	# same, without the lock prefix (legal too — the access check is identical)
	mov	rax, QWORD PTR [rdi]
	mov	rdx, QWORD PTR 8[rdi]
	mov	rbx, QWORD PTR 16[rdi]
	mov	rcx, QWORD PTR 24[rdi]
	mov	r8, QWORD PTR 56[rdi]
	mov	r9, QWORD PTR 64[rdi]
	mov	r10, QWORD PTR 72[rdi]
	cmpxchg16b	XMMWORD PTR [rsi]
	sete	cl
	mov	QWORD PTR 32[rdi], rax
	mov	QWORD PTR 40[rdi], rdx
	movzx	ecx, cl
	add	rcx, r8
	add	rcx, r9
	add	rcx, r10
	# (rbx read after the CAS: the hardware preserves it across the CAS
	# while it is also the implicit pinned desired-lo source)
	add	rcx, rbx
	mov	QWORD PTR 48[rdi], rcx
	ret
	.size	cas16_ul_test, .-cas16_ul_test
	.section	.note.GNU-stack,"",@progbits
