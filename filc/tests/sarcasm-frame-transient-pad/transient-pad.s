	.file	"transient-pad.c"
	.text
	.globl	foo_transient
	.type	foo_transient, @function
foo_transient:                  ;! long(long)
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	pushq	%rbx
	movq	%rdi, %rbx
	popq	%rbx
	movq	%rdi, -8(%rbp)
	movq	8(%rsp), %rax
	leave
	ret
	.size	foo_transient, .-foo_transient
	.globl	foo_prologue_save
	.type	foo_prologue_save, @function
foo_prologue_save:              ;! long(long)
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	subq	$8, %rsp
	movq	%rdi, %rbx
	movq	%rdi, -8(%rbp)
	movq	8(%rsp), %rax
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	ret
	.size	foo_prologue_save, .-foo_prologue_save
	.section	.note.GNU-stack,"",@progbits
