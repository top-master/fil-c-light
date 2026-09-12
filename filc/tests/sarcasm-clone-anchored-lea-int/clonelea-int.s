# Intel-syntax twin of the anchored-clone region-lea shape (see the -att test).
	.intel_syntax noprefix
	.text
	.globl	clone_anchored_lea
	.type	clone_anchored_lea, @function
clone_anchored_lea:             ;! long(ptr)
	push	rbx
	sub	rsp, 64               ;! alloca result size=64
	mov	rbx, QWORD PTR [rdi]
	call	helper
	mov	rax, QWORD PTR [rsp]  # caller reads region+0
	add	rsp, 64
	pop	rbx
	ret
	.size	clone_anchored_lea, .-clone_anchored_lea
	.type	helper, @function
helper:
	lea	rdi, [rsp+8]          # clone: region+0 via the +8 rule
	mov	QWORD PTR [rdi], rbx  # helper writes region+0
	ret
	.size	helper, .-helper
	.section	.note.GNU-stack,"",@progbits
