	.text
	.p2align 4
	.globl	foo
	.type	foo, @function
foo:                            ;! int(ptr, size_t)
	movq	(%rdi,%rsi,8), %rax ;! load ptr
	movl	(%rax), %eax
	ret
