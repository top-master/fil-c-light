	.text
	# `.alloca` with immediate size/alignment: allocate, write the whole range,
	# read it back. buf32/buf64 also hand their pointers to C for alignment
	# checks.
	.globl	dotalloca_roundtrip
	.type	dotalloca_roundtrip, @function
dotalloca_roundtrip:            ;! long(long)
	endbr64
	.alloca $32, $16, %rax
	movq	%rdi, (%rax)
	movq	%rdi, %rcx
	addq	$1, %rcx
	movq	%rcx, 8(%rax)
	movq	%rdi, %rcx
	addq	$2, %rcx
	movq	%rcx, 16(%rax)
	movq	%rdi, %rcx
	addq	$3, %rcx
	movq	%rcx, 24(%rax)
	movq	(%rax), %rdx
	addq	8(%rax), %rdx
	addq	16(%rax), %rdx
	addq	24(%rax), %rdx
	movq	%rdx, %rax
	ret
	.size	dotalloca_roundtrip, .-dotalloca_roundtrip
	.globl	dotalloca_buf32
	.type	dotalloca_buf32, @function
dotalloca_buf32:                ;! ptr()
	endbr64
	.alloca $64, $32, %rax
	ret
	.size	dotalloca_buf32, .-dotalloca_buf32
	.globl	dotalloca_buf64
	.type	dotalloca_buf64, @function
dotalloca_buf64:                ;! ptr()
	endbr64
	.alloca $64, $64, %rax
	ret
	.size	dotalloca_buf64, .-dotalloca_buf64
	.section	.note.GNU-stack,"",@progbits
