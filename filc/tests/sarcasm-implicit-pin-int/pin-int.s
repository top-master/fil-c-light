	.intel_syntax noprefix
	.text
	.globl	cpuid7_all_int
	.type	cpuid7_all_int, @function
cpuid7_all_int:                 ;! void(ptr)
	mov	eax, 7
	xor	ecx, ecx
	cpuid
	mov	QWORD PTR [rdi], rax
	mov	QWORD PTR [rdi+8], rbx
	mov	QWORD PTR [rdi+16], rcx
	mov	QWORD PTR [rdi+24], rdx
	ret
	.size	cpuid7_all_int, .-cpuid7_all_int

	.globl	cpuid_stress_int
	.type	cpuid_stress_int, @function
cpuid_stress_int:               ;! long(ptr)
	# Intel-syntax cpuid under register pressure: six value webs plus the
	# output-pointer arg stay live across the pinned rax/rbx/rcx/rdx.
	mov	eax, 7
	xor	ecx, ecx
	mov	r8, 11
	mov	r9, 22
	mov	r10, 33
	mov	r11, 44
	mov	rsi, 55
	mov	rbp, 66
	cpuid
	mov	QWORD PTR [rdi], rax
	mov	QWORD PTR [rdi+8], rbx
	mov	QWORD PTR [rdi+16], rcx
	mov	QWORD PTR [rdi+24], rdx
	lea	rax, [r8+r9]
	add	rax, r10
	add	rax, r11
	add	rax, rsi
	add	rax, rbp
	ret
	.size	cpuid_stress_int, .-cpuid_stress_int

	.globl	cpuid_own_int
	.type	cpuid_own_int, @function
cpuid_own_int:                  ;! long(long)
	# Pin in/out coalescing (Intel syntax): the user's own eax/ecx are the
	# cpuid inputs; all four outputs are read immediately.
	mov	eax, edi
	xor	ecx, ecx
	cpuid
	add	rax, rbx
	add	rax, rcx
	add	rax, rdx
	ret
	.size	cpuid_own_int, .-cpuid_own_int

	.globl	cpuid_heavy_int
	.type	cpuid_heavy_int, @function
cpuid_heavy_int:                ;! long()
	# Heavy pressure (Intel syntax): eleven webs live across the cpuid force
	# spill/reload around the pinned registers.
	mov	eax, 7
	xor	ecx, ecx
	mov	r8, 1
	mov	r9, 2
	mov	r10, 3
	mov	r11, 4
	mov	rsi, 5
	mov	rdi, 6
	mov	rbp, 7
	mov	r12, 8
	mov	r13, 9
	mov	r14, 10
	mov	r15, 11
	cpuid
	add	rax, r8
	add	rax, r9
	add	rax, r10
	add	rax, r11
	add	rax, rsi
	add	rax, rdi
	add	rax, rbp
	add	rax, r12
	add	rax, r13
	add	rax, r14
	add	rax, r15
	add	rax, rbx
	add	rax, rcx
	add	rax, rdx
	ret
	.size	cpuid_heavy_int, .-cpuid_heavy_int
	.section	.note.GNU-stack,"",@progbits
