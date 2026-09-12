	.intel_syntax noprefix
	.text
	# Intel-syntax twin of sarcasm-and-cap-att: `and` preserves capabilities.
	.globl	and_imm16
	.type	and_imm16, @function
and_imm16:                      ;! void(ptr,ptr)
	endbr64
	mov	rax, rdi
	and	rax, -16
	mov	rcx, QWORD PTR [rax]
	mov	QWORD PTR [rsi], rcx
	ret
	.size	and_imm16, .-and_imm16
	.globl	and_regmask
	.type	and_regmask, @function
and_regmask:                    ;! void(ptr,ptr,long)
	endbr64
	mov	rax, rdi
	and	rax, rdx
	mov	rcx, QWORD PTR [rax]
	mov	QWORD PTR [rsi], rcx
	ret
	.size	and_regmask, .-and_regmask
	.globl	and_down8
	.type	and_down8, @function
and_down8:                      ;! void(ptr,ptr)
	endbr64
	lea	rax, [rdi+8]
	and	rax, -16
	mov	rcx, QWORD PTR [rax]
	mov	QWORD PTR [rsi], rcx
	ret
	.size	and_down8, .-and_down8
	.globl	and_alloca16
	.type	and_alloca16, @function
and_alloca16:                   ;! long(long)
	endbr64
	.alloca 32, 16, rax
	mov	QWORD PTR [rax], rdi
	mov	rcx, rdi
	add	rcx, 1
	mov	QWORD PTR [rax+8], rcx
	and	rax, -16
	mov	rdx, QWORD PTR [rax]
	add	rdx, QWORD PTR [rax+8]
	mov	rax, rdx
	ret
	.size	and_alloca16, .-and_alloca16
	.section	.note.GNU-stack,"",@progbits
