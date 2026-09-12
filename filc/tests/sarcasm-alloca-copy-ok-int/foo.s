	.file	"alloca.c"
	.intel_syntax noprefix
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! void(ptr, size_t)
	push	rbp
	lea	rax, 23[0+rsi*4]
	and	rax, -16
	mov	rbp, rsp
	sub	rsp, rax        ;! alloca size (buf)
	lea	rcx, 15[rsp]    ;! alloca result (buf)
	and	rcx, -16
	test	rsi, rsi
	je	.L1
	lea	rax, -1[rsi]
	mov	rdx, rax
.L3:
	mov	esi, DWORD PTR [rdi+rdx*4]
	mov	DWORD PTR [rcx+rdx*4], esi
	sub	rdx, 1
	jnb	.L3
.L4:
	mov	edx, DWORD PTR [rcx+rax*4]
	mov	DWORD PTR [rdi+rax*4], edx
	sub	rax, 1
	jnb	.L4
.L1:
	leave
	ret
	.size	foo, .-foo
	.section	.note.GNU-stack,"",@progbits
