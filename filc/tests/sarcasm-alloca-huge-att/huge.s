# A 1 TiB `;! alloca` succeeds exactly like a malloc of that size: the GC
# allocation is lazily committed, so writing the FIRST and the LAST byte works
# and everything between stays untouched. (The last byte needs an address
# computation -- a disp32 cannot reach offset 1099511627768 -- so the top of
# the buffer is formed by adding the size-minus-8 in a register.) An access at
# offset == size traps with ptr >= upper (probed in the audit; covered by the
# generic OOB machinery, not re-pinned here).
	.text
	.globl	hugebuf
	.type	hugebuf, @function
hugebuf:                        ;! ptr()
	endbr64
	movq	$0, %rax
	leaq	-120(%rsp), %rcx    ;! alloca result size=1099511627776
	movq	$17, (%rcx)
	movabsq	$1099511627768, %rdx
	addq	%rcx, %rdx
	movq	$34, (%rdx)
	movq	(%rdx), %rsi
	movq	%rcx, %rax
	ret
	.size	hugebuf, .-hugebuf
	.section	.note.GNU-stack,"",@progbits
