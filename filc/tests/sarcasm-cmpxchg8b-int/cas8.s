	.intel_syntax noprefix
	.text
	.globl	cas8_test
	.type	cas8_test, @function
cas8_test:                      ;! void(ptr, ptr)
	# rdi -> struct { int expLo, expHi, desLo, desHi, oldLo, oldHi; long pad;
	#                 long live1, live2, flag; }   (ints at 0..20, live1=32,
	#                 live2=40, flag=48)
	# rsi -> 8-byte buffer. The implicit edx:eax (expected, mismatch
	# writeback) and ecx:ebx (desired) pairs are pinned through emitPinned;
	# the live1/live2 webs stay live ACROSS the pin.
	mov	eax, DWORD PTR [rdi]
	mov	edx, DWORD PTR 4[rdi]
	mov	ebx, DWORD PTR 8[rdi]
	mov	ecx, DWORD PTR 12[rdi]
	mov	r8, QWORD PTR 32[rdi]
	mov	r9, QWORD PTR 40[rdi]
	lock cmpxchg8b	QWORD PTR [rsi]
	# sete must IMMEDIATELY follow the CAS: sarcasm's injected bounds checks
	# (for the stores below) clobber EFLAGS (a documented sarcasm property).
	sete	cl
	mov	DWORD PTR 16[rdi], eax
	mov	DWORD PTR 20[rdi], edx
	movzx	ecx, cl
	add	rcx, r8
	add	rcx, r9
	mov	QWORD PTR 48[rdi], rcx
	ret
	.size	cas8_test, .-cas8_test

	.globl	cas8_ul_test
	.type	cas8_ul_test, @function
cas8_ul_test:                   ;! void(ptr, ptr)
	# same, without the lock prefix (legal too — the access check is identical)
	mov	eax, DWORD PTR [rdi]
	mov	edx, DWORD PTR 4[rdi]
	mov	ebx, DWORD PTR 8[rdi]
	mov	ecx, DWORD PTR 12[rdi]
	mov	r8, QWORD PTR 32[rdi]
	mov	r9, QWORD PTR 40[rdi]
	cmpxchg8b	QWORD PTR [rsi]
	sete	cl
	mov	DWORD PTR 16[rdi], eax
	mov	DWORD PTR 20[rdi], edx
	movzx	ecx, cl
	add	rcx, r8
	add	rcx, r9
	mov	QWORD PTR 48[rdi], rcx
	ret
	.size	cas8_ul_test, .-cas8_ul_test
	.section	.note.GNU-stack,"",@progbits
