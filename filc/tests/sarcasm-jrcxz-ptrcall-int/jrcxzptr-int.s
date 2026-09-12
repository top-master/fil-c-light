# Intel-syntax twin of sarcasm-jrcxz-ptrcall-att: jrcxz right after a
# pointer-returning annotated call (direct and indirect, taken and not-taken).
# Under the FIP CC the ptr result lower arrives in retLo = rcx, so the counter
# web (pinned to physical rcx) is DEFINED from the result's lower web after the
# call's result unpacking; pre-fix the saved entry counter was restored instead
# and the jrcxz branched on stale garbage.
# Hardware ground truth (plain as + gcc): jzeroret(9) = 0, passthru(p) = 1,
# passthru(NULL) = 0, icall(ident) = 1, icall(nulid) = 0.
	.intel_syntax noprefix
	.text
	.globl	jzeroret
	.type	jzeroret, @function
jzeroret:                       ;! long(long)
	endbr64
	call	zeroer             ;! ptr(long)
	jrcxz	.Jzero
	mov	eax, 1
	ret
.Jzero:
	xor	eax, eax
	ret
	.size	jzeroret, .-jzeroret
	.globl	passthru
	.type	passthru, @function
passthru:                       ;! long(ptr)
	endbr64
	call	ident              ;! ptr(ptr)
	jrcxz	.Pzero
	mov	eax, 1
	ret
.Pzero:
	xor	eax, eax
	ret
	.size	passthru, .-passthru
	.globl	icall
	.type	icall, @function
icall:                          ;! long(ptr)
	endbr64
	mov	rax, rdi
	call	rax                ;! ptr(ptr)
	jrcxz	.Izero
	mov	eax, 1
	ret
.Izero:
	xor	eax, eax
	ret
	.size	icall, .-icall
	.globl	zeroer
	.type	zeroer, @function
zeroer:                         ;! ptr(long)
	endbr64
	mov	rax, rdi
	xor	ecx, ecx
	ret
	.size	zeroer, .-zeroer
	.globl	ident
	.type	ident, @function
ident:                          ;! ptr(ptr)
	endbr64
	mov	rax, rdi
	mov	rcx, rdi
	ret
	.size	ident, .-ident
	.globl	nulid
	.type	nulid, @function
nulid:                          ;! ptr(ptr)
	endbr64
	xor	eax, eax
	xor	ecx, ecx
	ret
	.size	nulid, .-nulid
	.section	.note.GNU-stack,"",@progbits
