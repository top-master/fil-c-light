# The exact OpenSSL shape: `.type _sub,@function`, NOT .globl, no signature,
# the sub defined BEFORE its caller, with .cfi_* directives and .align — an
# unannotated `call _sub` resolves to the local subroutine (custom convention:
# arg %r10/%r11, result %r9).
	.text
	.type	_helper, @function
	.align	16
_helper:
.cfi_startproc
	leaq	(%r10,%r11), %r9
	shlq	$2, %r9
	.byte	0xf3,0xc3           # rep ret (decoded)
.cfi_endproc
	.size	_helper, .-_helper
	.globl	foo
	.type	foo, @function
	.align	16
foo:                            ;! long(long)
.cfi_startproc
	movq	%rdi, %r10
	movq	%rdi, %r11
	addq	$5, %r11
	call	_helper
	leaq	1(%r9), %rax
	ret
.cfi_endproc
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
