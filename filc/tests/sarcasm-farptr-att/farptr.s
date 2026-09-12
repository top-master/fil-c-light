	.text
	.globl	farptr_lgs32
	.type	farptr_lgs32, @function
farptr_lgs32:                   ;! long(ptr)
	# lgs m16:32 — a 6-byte far-pointer load (4-byte offset + 2-byte selector)
	# from a 6-byte allocation. The old width logic checked only the 4-byte
	# destination size — a silent 2-byte overread. Selector word is 0, which
	# is safe to load into gs in-process.
	# (lgs with a 64-bit destination — a 10-byte load — is deliberately not
	# exercised: GNU as 2.42 cannot encode `lgs mem, %r64`. lfs/lss are not
	# exercised either: loading fs with a null selector zeroes the FS base on
	# this machine and kills TLS, and ss loads can #GP.)
	lgs	(%rdi), %eax
	movw	%gs, %cx
	movzwl	%cx, %ecx
	shlq	$32, %rcx
	orq	%rcx, %rax        # return (gs << 32) | offset
	ret
	.size	farptr_lgs32, .-farptr_lgs32
	.globl	farptr_lgs16
	.type	farptr_lgs16, @function
farptr_lgs16:                   ;! long(ptr)
	# lgs m16:16 — a 4-byte far-pointer load (2-byte offset + 2-byte
	# selector) at offset 2 in the same 6-byte allocation: [2,6) fits exactly.
	# NB: a 16-bit lgs leaves the upper bits of the destination register
	# unchanged (and the emitted bounds check uses %rax as scratch), so the
	# loaded offset must be zero-extended explicitly after the load.
	lgs	2(%rdi), %ax
	movzwl	%ax, %eax
	movw	%gs, %cx
	movzwl	%cx, %ecx
	shlq	$32, %rcx
	orq	%rcx, %rax
	ret
	.size	farptr_lgs16, .-farptr_lgs16
	.section	.note.GNU-stack,"",@progbits
