# A mid-function lea into %rsp whose base is not the frame pointer must be
# rejected whatever the operand spelling. In an AT&T-parsed file a dest-first
# Intel spelling (`lea rsp, [rax+15]`) parses as a symbol source over a
# non-register destination — a %rsp write the model cannot see — so it must be
# rejected with the stack-pointer-write error, never emitted verbatim.
	.file	"lea-rsp-regbase.c"
	.text
	.globl	leabase
	.type	leabase, @function
leabase:                        ;! long(long)
	endbr64
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	$7, %eax
	lea	rsp, [rax+15]
	movq	-8(%rbp), %rax
	addq	$3, %rax
	leave
	ret
	.size	leabase, .-leabase
	.section	.note.GNU-stack,"",@progbits
