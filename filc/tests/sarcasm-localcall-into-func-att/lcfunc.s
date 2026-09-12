# A local call into a SIGNATURED function's alias-entry body (the mont5
# `call __bn_sqr8x_internal` shape): `__sum5_body` is a second, entry-adjacent
# label of the sig'd, exported `sum5`. The unannotated call claims the whole
# function body as a per-caller clone (frame setup included; its ret
# dispatches to the continuation) — the only sound reading, because such a
# body may use the +8 caller-frame convention no standalone callee may use.
# The exported symbol must ALSO keep working as an ordinary Fil-C call.
	.text
	.globl	sum5
	.type	sum5, @function
sum5:                           #! void(ptr,long,long,long,long,long)
__sum5_body:
	movq	%rsi, %rax
	addq	%rdx, %rax
	addq	%rcx, %rax
	addq	%r8, %rax
	addq	%r9, %rax
	movq	%rax, (%rdi)
	ret
	.size	sum5, .-sum5
	.globl	caller6
	.type	caller6, @function
caller6:                        #! void(ptr)
	movq	$1, %rsi
	movq	$2, %rdx
	movq	$3, %rcx
	movq	$4, %r8
	movq	$5, %r9
	call	__sum5_body
	ret
	.size	caller6, .-caller6
	.section	.note.GNU-stack,"",@progbits
