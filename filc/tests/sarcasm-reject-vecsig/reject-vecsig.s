# SIMD/vector signatures stay rejected on x86_64: a vec4 signature would need
# full vector-register CC machinery (and vec5/vec6 filcc signature words do not
# even follow the standard formula).
	.text
	.globl	vf
	.type	vf, @function
vf:                             ;! vec4(vec4)
	endbr64
	movq	%rdi, %rax
	ret
	.size	vf, .-vf
	.section	.note.GNU-stack,"",@progbits
