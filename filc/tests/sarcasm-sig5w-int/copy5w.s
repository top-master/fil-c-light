# Intel-syntax twin of sarcasm-sig5w-att (same void(ptr,ptr,size_t) 5-word
# signature shape: the size_t arrives on the stack, %rdx wants it in SysV).
	.intel_syntax noprefix
	.text
	.globl	copy5w
	.type	copy5w, @function
copy5w:                         #! void(ptr,ptr,size_t)
	test	rdx, rdx
	je	.Ldone
.Lloop:
	movzx	eax, byte ptr [rsi]
	mov	[rdi], al
	inc	rsi
	inc	rdi
	dec	rdx
	jne	.Lloop
.Ldone:
	ret
	.size	copy5w, .-copy5w
	.section	.note.GNU-stack,"",@progbits
