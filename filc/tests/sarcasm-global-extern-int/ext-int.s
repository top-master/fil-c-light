	.intel_syntax noprefix
	.text
	.globl	ext_lea
	.type	ext_lea, @function
ext_lea:                        ;! long(long)
	lea	rax, [rip+g] #! global ptr
	mov	eax, DWORD PTR [rax+rdi*4]
	ret
	.size	ext_lea, .-ext_lea
	.globl	ext_direct
	.type	ext_direct, @function
ext_direct:                     ;! long()
	mov	eax, DWORD PTR [rip+g+8] #! global ptr
	add	eax, DWORD PTR [rip+g+12] #! global ptr
	ret
	.size	ext_direct, .-ext_direct
	.globl	ext_store
	.type	ext_store, @function
ext_store:                      ;! void(long,long)
	lea	rax, [rip+g] #! global ptr
	mov	DWORD PTR [rax+rdi*4], esi
	ret
	.size	ext_store, .-ext_store
	.section	.note.GNU-stack,"",@progbits
