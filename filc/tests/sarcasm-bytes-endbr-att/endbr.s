# OpenSSL perlasm emits CET landing pads as raw bytes at function entry:
# `.byte 243,15,30,250` (decimal) or `.byte 0xf3,0x0f,0x1e,0xfa` (hex), both
# spelling endbr64 (f3 0f 1e fa). Sarcasm models endbr64 as a nop already, so
# the decoded byte form must behave exactly like the spelled one. One function
# uses each spelling; a third interleaves the entry pad with a spelled endbr64.
	.text
	.globl	cetdec
	.type	cetdec, @function
cetdec:                         ;! long(long)
	.byte	243,15,30,250       # endbr64, decimal spelling
	movq	%rdi, %rax
	addq	$2, %rax
	ret
	.size	cetdec, .-cetdec
	.globl	cethex
	.type	cethex, @function
cethex:                         ;! long(long)
	.byte	0xf3,0x0f,0x1e,0xfa # endbr64, hex spelling
	movq	%rdi, %rax
	addq	$3, %rax
	ret
	.size	cethex, .-cethex
	.globl	cetmix
	.type	cetmix, @function
cetmix:                         ;! long(long)
	.byte	0xf3,0x0f,0x1e,0xfa
	endbr64                     # a spelled landing pad right after the byte one
	movq	%rdi, %rax
	addq	$4, %rax
	ret
	.size	cetmix, .-cetmix
	.section	.note.GNU-stack,"",@progbits
