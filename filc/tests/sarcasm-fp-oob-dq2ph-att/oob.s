	.text
	.globl	dq2ph_oob
	.type	dq2ph_oob, @function
dq2ph_oob:                      ;! void(ptr, ptr)
	# Bare vcvtdq2ph with a ymm destination reads an m512 source — a FULL
	# 64 bytes (the narrowing-convert fix: the .512 form has no z-suffixed
	# spelling, so the bare ymm-dest form is unambiguous). rsi points 8
	# bytes before the end of a 64-byte object: an under-check at the
	# 32-byte destination width (or a rejection of the form) would miss
	# it; the 64-byte check traps. The bounds check fires before the
	# instruction executes, so this proves the width even though
	# vcvtdq2ph is an AVX512-FP16 instruction that this machine cannot
	# execute.
	vcvtdq2ph	(%rsi), %ymm0
	ret
	.size	dq2ph_oob, .-dq2ph_oob
	.section	.note.GNU-stack,"",@progbits
