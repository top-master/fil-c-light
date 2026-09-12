/* SIMD/vector signatures stay rejected on arm64: a vec4 signature would need
   q-register CC machinery (and vec5/vec6 filcc signature words do not even follow
   the standard formula). */
	.text
	.global	vf
	.type	vf, %function
vf:                             ;! vec4(vec4)
	ret
	.size	vf, .-vf
