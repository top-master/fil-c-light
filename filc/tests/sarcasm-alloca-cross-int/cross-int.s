# Intel-syntax twin of sarcasm-alloca-cross-att: two allocas in one function
# are INDEPENDENT GC allocations, not adjacent regions of one frame: advancing
# A's pointer by exactly A's size -- where B would sit if these were real stack
# allocations -- lands ON A's upper bound, and a store through it traps
# (ptr >= upper).
	.intel_syntax noprefix
	.text
	.globl	cross
	.type	cross, @function
cross:                          ;! void()
	endbr64
	mov	rax, 0
	lea	rcx, [rsp-120]      ;! alloca result size=64
	lea	r8, [rsp-200]       ;! alloca result size=64
	mov	QWORD PTR [rcx], 119
	mov	QWORD PTR [r8], 136
	add	rcx, 64
	mov	QWORD PTR [rcx], 153
	ret
	.size	cross, .-cross
	.section	.note.GNU-stack,"",@progbits
