# The bn_mul_mont_gather5 shape: a 7-argument function whose 7th argument is a
# SysV STACK argument read at entry with an FP/vector instruction
# (`movd 8(%rsp), %xmm5`). This signature — void(ptr,ptr,ptr,ptr,ptr,ptr,int)
# — is THIRTEEN fast-CC argument words. FP instructions cannot ride the GPR
# argument-slot webs, so sarcasm materializes the incoming stack arguments
# into a reserved frame area (filled by the entry unpack from the incoming
# fast-CC words) and rewrites the read to it.
	.text
	.globl	sum7w
	.type	sum7w, @function
sum7w:                          #! long(ptr,ptr,ptr,ptr,ptr,ptr,int)
	movd	8(%rsp), %xmm5
	movq	(%rdi), %rax
	addq	(%rsi), %rax
	addq	(%rdx), %rax
	addq	(%rcx), %rax
	addq	(%r8), %rax
	addq	(%r9), %rax
	pshufd	$0, %xmm5, %xmm5
	movd	%xmm5, %ecx
	addq	%rcx, %rax
	ret
	.size	sum7w, .-sum7w
	.section	.note.GNU-stack,"",@progbits
