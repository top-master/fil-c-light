# Intel-syntax twin of sarcasm-bytes-frame-att: the .byte decode is
# syntax-independent (raw encodings mean the same in either input syntax), so a
# byte-encoded prologue adjustment / entry pad / rep ret interleave freely with
# Intel-spelled instructions.
	.intel_syntax noprefix
	.text
	.globl	iframed
	.type	iframed, @function
iframed:                        ;! long(long)
	.byte	243,15,30,250       # endbr64 at entry
	push	rbx
	.byte	0x48,0x83,0xEC,0x08 # sub rsp, 8 — the prologue adjustment as bytes
	mov	QWORD PTR [rsp], rdi
	mov	rax, QWORD PTR [rsp]
	add	rax, 7
	add	rsp, 8
	pop	rbx
	.byte	0xf3,0xc3           # rep ret
	.size	iframed, .-iframed
	.section	.note.GNU-stack,"",@progbits
