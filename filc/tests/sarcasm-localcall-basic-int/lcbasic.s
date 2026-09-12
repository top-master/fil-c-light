# Intel-syntax twin of the basic local-subroutine test: custom convention (arg
# in r10, result in r9), called twice.
	.intel_syntax noprefix
	.text
	.globl	foo
	.type	foo, @function
foo:                            ;! long(long)
	mov	r10, rdi
	call	dbladd
	lea	rbx, [r9+r9]
	mov	r10, rbx
	call	dbladd
	lea	rax, [rbx+r9]
	ret
	.size	foo, .-foo
	.type	dbladd, @function
dbladd:
	lea	r9, [r10+r10]
	add	r9, 3
	ret
	.size	dbladd, .-dbladd
	.section	.note.GNU-stack,"",@progbits
