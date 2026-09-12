# AT&T: a user label named EXACTLY like another function's generated rel8
# trampoline name. The .Lsarctramp_<fn>_<n>{t,s} names are file-global assembly
# symbols; the trampoline allocator used to skip only the CURRENT function's
# labels, so a user label in fna named .Lsarctramp_fnb_0t/.Lsarctramp_fnb_1t
# collided with fnb's own generated trampoline names and gas died on the temp
# file with the opaque "symbol .Lsarctramp_fnb_0t' is already defined" plus a
# knock-on rel8 error. The allocator now bumps past every user label name in the
# FILE (and this test forces the bump loop to run twice for fnb: both 0t/0s and
# 1t/1s are taken by fna's user labels, so fnb's two loops land on 2t/2s).
# Hardware ground truth (plain as + gcc): fna(4) = 4, fnb(5) = 10.
	.text
	.globl	fna
	.type	fna, @function
fna:                            ;! long(long)
	endbr64
	xorl	%eax, %eax
.Lsarctramp_fnb_0t:
.Lsarctramp_fnb_1t:
	movq	%rdi, %rcx
.Lfna_top:
	incl	%eax
	loop	.Lfna_top
	ret
	.size	fna, .-fna
	.globl	fnb
	.type	fnb, @function
fnb:                            ;! long(long)
	endbr64
	xorl	%eax, %eax
	movq	%rdi, %rcx
.Lfnb_top:
	incl	%eax
	loop	.Lfnb_top
	movq	%rax, %rcx
.Lfnb_top2:
	incl	%eax
	loop	.Lfnb_top2
	ret
	.size	fnb, .-fnb
	.section	.note.GNU-stack,"",@progbits
