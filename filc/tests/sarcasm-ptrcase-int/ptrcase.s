	.intel_syntax noprefix
	.text
	# Annotated pointer accesses whose PTR keyword is NOT uppercase: the parser
	# must accept any casing of `ptr` (real assemblers do) and emit the same
	# bounds-checked code as for the canonical `QWORD PTR`. The driver checks
	# that every casing stores and loads real pointer capabilities.
	.globl	pc_store_lower
	.type	pc_store_lower, @function
pc_store_lower:                 ;! void(ptr, ptr)
	mov	qword ptr [rdi], rsi    ;! store ptr
	ret
	.size	pc_store_lower, .-pc_store_lower

	.globl	pc_store_mixed1
	.type	pc_store_mixed1, @function
pc_store_mixed1:                ;! void(ptr, ptr)
	mov	QWORD ptr [rdi], rsi    ;! store ptr
	ret
	.size	pc_store_mixed1, .-pc_store_mixed1

	.globl	pc_store_mixed2
	.type	pc_store_mixed2, @function
pc_store_mixed2:                ;! void(ptr, ptr)
	mov	qword PTR [rdi], rsi    ;! store ptr
	ret
	.size	pc_store_mixed2, .-pc_store_mixed2

	.globl	pc_store_mixed3
	.type	pc_store_mixed3, @function
pc_store_mixed3:                ;! void(ptr, ptr)
	mov	Qword Ptr [rdi], rsi    ;! store ptr
	ret
	.size	pc_store_mixed3, .-pc_store_mixed3

	.globl	pc_store_upper
	.type	pc_store_upper, @function
	# canonical uppercase control: QWORD PTR
pc_store_upper:                 ;! void(ptr, ptr)
	mov	QWORD PTR [rdi], rsi    ;! store ptr
	ret
	.size	pc_store_upper, .-pc_store_upper

	.globl	pc_load_lower
	.type	pc_load_lower, @function
pc_load_lower:                  ;! ptr(ptr)
	mov	rax, qword ptr [rdi]    ;! load ptr
	ret
	.size	pc_load_lower, .-pc_load_lower

	.globl	pc_load_mixed
	.type	pc_load_mixed, @function
pc_load_mixed:                  ;! ptr(ptr)
	mov	rax, QWORD ptr [rdi]    ;! load ptr
	ret
	.size	pc_load_mixed, .-pc_load_mixed

	# Sub-pointer-width data accesses with lowercase PTR keywords of every
	# size word; the driver mirrors the arithmetic in C.
	.globl	pc_arith
	.type	pc_arith, @function
pc_arith:                       ;! void(ptr)
	add	qword ptr [rdi], 5
	add	dword ptr [rdi+8], 3
	add	word ptr [rdi+12], 2
	add	byte ptr [rdi+14], 1
	ret
	.size	pc_arith, .-pc_arith
	.section	.note.GNU-stack,"",@progbits
