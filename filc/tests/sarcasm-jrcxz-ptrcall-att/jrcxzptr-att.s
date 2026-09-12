# GAP probe (AT&T): jrcxz right after a POINTER-returning annotated call, in all
# four shapes: direct call with a zero lower (taken), direct call passing a real
# pointer through (not-taken; and taken for a NULL pointer), and INDIRECT calls
# through a flight pointer (not-taken via a real returned lower, taken via a
# zero returned lower). Under the FIP CC a ptr-returning callee delivers its
# result lower in retLo = rcx, so hardware rcx after the call IS the returned
# lower: the counter web (pinned to physical rcx) is DEFINED from the result's
# lower web after the call's result unpacking. Pre-fix the saved entry counter
# was restored instead — stomping the returned lower — and the jrcxz branched on
# stale garbage.
# Hardware ground truth (plain as + gcc): jzeroret(9) = 0, passthru(p) = 1,
# passthru(NULL) = 0, icall(ident) = 1, icall(nulid) = 0.
	.text
	.globl	jzeroret
	.type	jzeroret, @function
jzeroret:                       ;! long(long)
	endbr64
	call	zeroer             ;! ptr(long)
	jrcxz	.Jzero
	movl	$1, %eax
	ret
.Jzero:
	xorl	%eax, %eax
	ret
	.size	jzeroret, .-jzeroret
	.globl	passthru
	.type	passthru, @function
passthru:                       ;! long(ptr)
	endbr64
	call	ident              ;! ptr(ptr)
	jrcxz	.Pzero
	movl	$1, %eax
	ret
.Pzero:
	xorl	%eax, %eax
	ret
	.size	passthru, .-passthru
	.globl	icall
	.type	icall, @function
icall:                          ;! long(ptr)
	endbr64
	movq	%rdi, %rax
	call	*%rax              ;! ptr(ptr)
	jrcxz	.Izero
	movl	$1, %eax
	ret
.Izero:
	xorl	%eax, %eax
	ret
	.size	icall, .-icall
	.globl	zeroer
	.type	zeroer, @function
zeroer:                         ;! ptr(long)
	endbr64
	movq	%rdi, %rax
	xorl	%ecx, %ecx
	ret
	.size	zeroer, .-zeroer
	.globl	ident
	.type	ident, @function
ident:                          ;! ptr(ptr)
	endbr64
	movq	%rdi, %rax
	movq	%rdi, %rcx
	ret
	.size	ident, .-ident
	.globl	nulid
	.type	nulid, @function
nulid:                          ;! ptr(ptr)
	endbr64
	xorl	%eax, %eax
	xorl	%ecx, %ecx
	ret
	.size	nulid, .-nulid
	.section	.note.GNU-stack,"",@progbits
