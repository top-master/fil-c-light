# Intel-syntax twin of sarcasm-alloca-huge-att: a 1 TiB `;! alloca` succeeds
# exactly like a malloc of that size: the GC allocation is lazily committed, so
# writing the FIRST and the LAST byte works and everything between stays
# untouched. (The last byte needs an address computation -- a disp32 cannot
# reach offset 1099511627768 -- so the top of the buffer is formed by adding
# the size-minus-8 in a register.)
	.intel_syntax noprefix
	.text
	.globl	hugebuf
	.type	hugebuf, @function
hugebuf:                        ;! ptr()
	endbr64
	mov	rax, 0
	lea	rcx, [rsp-120]      ;! alloca result size=1099511627776
	mov	QWORD PTR [rcx], 17
	mov	rdx, 1099511627768
	add	rdx, rcx
	mov	QWORD PTR [rdx], 34
	mov	rsi, QWORD PTR [rdx]
	mov	rax, rcx
	ret
	.size	hugebuf, .-hugebuf
	.section	.note.GNU-stack,"",@progbits
