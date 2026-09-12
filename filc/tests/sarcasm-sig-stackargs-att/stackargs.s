# The aesni_ocb_encrypt shape: void(ptr,ptr,size_t,ptr,size_t,ptr,ptr,ptr) is
# FOURTEEN fast-CC argument words, and arguments 7 and 8 (the two trailing
# pointers) are SysV STACK arguments the body reads AT ENTRY via
# movq 8(%rsp) / movq 16(%rsp) in the prologue (before its own frame setup).
# sarcasm redirects those reads to virtual argument-slot webs fed from the
# incoming fast-CC words (intval + capability lower), so the loads through
# them are bounds-checked exactly like register arguments.
	.text
	.globl	sum8w
	.type	sum8w, @function
sum8w:                          #! long(ptr,ptr,size_t,ptr,size_t,ptr,ptr,ptr)
	movq	8(%rsp), %r10
	movq	16(%rsp), %r11
	movq	(%rdi), %rax
	addq	(%rsi), %rax
	addq	%rdx, %rax
	addq	(%rcx), %rax
	addq	%r8, %rax
	addq	(%r9), %rax
	addq	(%r10), %rax
	addq	(%r11), %rax
	ret
	.size	sum8w, .-sum8w
	.section	.note.GNU-stack,"",@progbits
