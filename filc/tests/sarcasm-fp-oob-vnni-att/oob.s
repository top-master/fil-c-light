	.text
	.globl	vnni_oob
	.type	vnni_oob, @function
vnni_oob:                       ;! void(ptr, ptr)
	# vpdpwssd reads a FULL 64-byte vector from memory; the ss/sd suffix rule
	# used to under-check it at 8 bytes. rsi points 8 bytes before the end of
	# a 64-byte object: the 8-byte check would pass, the 64-byte check traps.
	vpdpwssd	(%rsi), %zmm0, %zmm1
	ret
	.size	vnni_oob, .-vnni_oob
	.section	.note.GNU-stack,"",@progbits
