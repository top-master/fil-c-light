	.text
	.globl	cvt_oob
	.type	cvt_oob, @function
cvt_oob:                        ;! void(ptr, ptr)
	# vcvtuqq2ps ymm, m512: the memory source is 2x the destination width
	# (8 qwords -> 8 singles), i.e. 64 bytes. It used to be under-checked at
	# the 32-byte destination width. rsi points 32 bytes before the end of a
	# 64-byte object: the 32-byte check would pass, the 64-byte check traps.
	vcvtuqq2ps	(%rsi), %ymm0
	ret
	.size	cvt_oob, .-cvt_oob
	.section	.note.GNU-stack,"",@progbits
