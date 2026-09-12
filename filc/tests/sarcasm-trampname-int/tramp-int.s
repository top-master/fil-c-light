# Intel-syntax twin of sarcasm-trampname-att: user labels named exactly like
# another function's generated rel8 trampoline names (.Lsarctramp_fnb_0t and
# .Lsarctramp_fnb_1t live in fna; fnb's two loops must generate trampolines that
# bump past BOTH, landing on .Lsarctramp_fnb_2t). Pre-fix gas died on the temp
# file with the opaque "symbol .Lsarctramp_fnb_0t' is already defined" error.
# Hardware ground truth (plain as + gcc): fna(4) = 4, fnb(5) = 10.
	.intel_syntax noprefix
	.text
	.globl	fna
	.type	fna, @function
fna:                            ;! long(long)
	endbr64
	xor	eax, eax
.Lsarctramp_fnb_0t:
.Lsarctramp_fnb_1t:
	mov	rcx, rdi
.Lfna_top:
	inc	eax
	loop	.Lfna_top
	ret
	.size	fna, .-fna
	.globl	fnb
	.type	fnb, @function
fnb:                            ;! long(long)
	endbr64
	xor	eax, eax
	mov	rcx, rdi
.Lfnb_top:
	inc	eax
	loop	.Lfnb_top
	mov	rcx, rax
.Lfnb_top2:
	inc	eax
	loop	.Lfnb_top2
	ret
	.size	fnb, .-fnb
	.section	.note.GNU-stack,"",@progbits
