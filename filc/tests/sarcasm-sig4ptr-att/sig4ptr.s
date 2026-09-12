# Four pointer arguments: void(ptr,ptr,ptr,ptr) is EIGHT fast-CC argument words
# (every pointer is an intval+lower pair), so the third and fourth pointers
# arrive entirely on the stack — formerly the "too many args" rejection. Each
# pointer's capability lower must arrive with it for the loads to pass their
# bounds checks.
	.text
	.globl	sum4p
	.type	sum4p, @function
sum4p:                          #! long(ptr,ptr,ptr,ptr)
	movq	(%rdi), %rax
	addq	(%rsi), %rax
	addq	(%rdx), %rax
	addq	(%rcx), %rax
	ret
	.size	sum4p, .-sum4p
	.section	.note.GNU-stack,"",@progbits
