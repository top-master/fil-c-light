	.intel_syntax noprefix
	.text
	.globl	narrow_zx
	.type	narrow_zx, @function
narrow_zx:                      ;! long(ptr)
	# Legit narrowing exemption: movzx/movsx take their check width from the
	# PTR annotation (2/1/4 bytes here), NOT the destination register width —
	# the exact-end placements would trap on an over-check.
	movzx	eax, WORD PTR [rdi]
	ret
	.size	narrow_zx, .-narrow_zx
	.globl	narrow_sx_byte
	.type	narrow_sx_byte, @function
narrow_sx_byte:                 ;! long(ptr)
	movsx	eax, BYTE PTR [rdi]
	ret
	.size	narrow_sx_byte, .-narrow_sx_byte
	.globl	narrow_sxd
	.type	narrow_sxd, @function
narrow_sxd:                     ;! long(ptr)
	movsxd	rax, DWORD PTR [rdi]
	ret
	.size	narrow_sxd, .-narrow_sxd
	.section	.note.GNU-stack,"",@progbits
