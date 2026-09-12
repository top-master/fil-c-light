	.text
	.globl	movss_live
	.type	movss_live, @function
movss_live:                     ;! long(ptr)
	# xmm3 is live at exactly 4 bytes (movss/addss scalar width) across the
	# injected filc_allocate call below: the width-aware save/restore must be
	# a single movss store + movss load at slot 3 (16 + 3*vecBytes
	# pre-shift) — no other register, no wider form. (-S verified.)
	movss	(%rdi), %xmm3
	addss	%xmm3, %xmm3
	leaq	32(%rsp), %rax      ;! alloca result size=32
	movss	%xmm3, (%rax)
	movl	(%rax), %eax
	ret
	.size	movss_live, .-movss_live
	.section	.note.GNU-stack,"",@progbits
