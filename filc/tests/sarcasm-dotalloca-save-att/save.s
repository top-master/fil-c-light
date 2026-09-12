	.text
	# A standalone `save capability` annotation on the `.alloca` directive
	# itself records the fresh allocation's capability for a later restore.
	# The buffer holds its own address (a self-pointer), so dereferencing
	# through the restored capability is in-bounds.
	.globl	dotalloca_save
	.type	dotalloca_save, @function
dotalloca_save:                 ;! long()
	endbr64
	.alloca $32, $16, %rax  #! save capability (buf)
	movq	%rax, (%rax)
	movq	%rax, %rdx
	movq	(%rax), %rcx
	addq	$0, %rcx  #! restore capability (buf)
	movq	(%rcx), %rcx
	xorq	%rax, %rax
	cmpq	%rdx, %rcx
	sete	%al
	movzbq	%al, %rax
	ret
	.size	dotalloca_save, .-dotalloca_save
	.section	.note.GNU-stack,"",@progbits
