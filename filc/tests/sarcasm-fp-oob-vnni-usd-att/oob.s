	.text
	.globl	vnni_usd_oob
	.type	vnni_usd_oob, @function
vnni_usd_oob:                   ;! void(ptr, ptr)
	# vpdpwusd (the cross-sign VNNI word dot product) reads a FULL vector
	# from memory — 32 bytes for the ymm form. The ss/sd scalar suffix
	# rule used to under-check it at 8 bytes. rsi points 8 bytes before
	# the end of a 64-byte object: the 8-byte check would pass, the
	# 32-byte check traps (the bounds check fires before the instruction
	# itself executes, so this is meaningful even on machines without the
	# VNNI-INT16 silicon this VEX encoding belongs to).
	vpdpwusd	(%rsi), %ymm0, %ymm1
	ret
	.size	vnni_usd_oob, .-vnni_usd_oob
	.section	.note.GNU-stack,"",@progbits
