# Intel-syntax twin of sarcasm-recurse-gc-att: deep BOUNDED recursion (20000
# frames) with live rooted pointers and GC churn at every level: each frame
# roots its incoming pointer across a C call that mallocs 96 objects, plus its
# own alloca scratch buffer whose content is verified after the recursive call
# returns. The pointer passed down is returned unchanged and the bottom frame
# writes a sentinel through it.
	.intel_syntax noprefix
	.text
	.globl	recurse
	.type	recurse, @function
recurse:                        ;! ptr(ptr, long)
	endbr64
	mov	rbx, rdi
	test	rsi, rsi
	je	.Lbase
	lea	rcx, [rsp-120]      ;! alloca result size=64
	mov	rdx, 0x3d2c2a2826242220
	mov	QWORD PTR [rcx], rdx
	mov	r8, rsi
	sub	r8, 1
	mov	rdi, 96
	call	churn               ;! void(long)
	mov	rdi, rbx
	mov	rsi, r8
	call	recurse             ;! ptr(ptr, long)
	mov	r8, rax
	mov	rdx, 0x3d2c2a2826242220
	cmp	QWORD PTR [rcx], rdx
	jne	.Lbad
	mov	rax, r8
	ret
.Lbad:
	xor	eax, eax
	ret
.Lbase:
	mov	rdx, 0x5500550055005500
	mov	QWORD PTR [rbx], rdx
	mov	rax, rbx
	ret
	.size	recurse, .-recurse
	.section	.note.GNU-stack,"",@progbits
