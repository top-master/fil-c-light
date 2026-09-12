# OpenSSL perlasm encodes prologue stack adjustments as raw bytes. The decoded
# forms must be REAL sub/lea instructions to the frame analysis — a fake or
# dropped one would desync the stack-depth model. Covered here:
#   48 83 ec 08                 subq $8,%rsp
#   48 83 ec 28                 subq $40,%rsp
#   48 81 ec 08 01 00 00        subq $0x108,%rsp
#   4c 8d 14 24                 leaq (%rsp),%r10
# The lea form is a stack-address computation: like the spelled form it is only
# accepted where an rsp-relative lea already is — inside a fixed-alloca region,
# where the transform redirects it to the allocation pointer (see
# sarcasm-alloca-redirect-lea); elsewhere both forms reject identically.
	.text
	.globl	framed8
	.type	framed8, @function
framed8:                        ;! long(long)
	pushq	%rbx
	.byte	0x48,0x83,0xEC,0x08 # subq $8,%rsp — the prologue adjustment as bytes
	movq	%rdi, 0(%rsp)
	movq	0(%rsp), %rax
	addq	$7, %rax
	addq	$8, %rsp
	popq	%rbx
	ret
	.size	framed8, .-framed8
	.globl	framed40
	.type	framed40, @function
framed40:                       ;! long(long)
	.byte	0x48,0x83,0xEC,0x28 # subq $40,%rsp (bare frame, no pushes)
	movq	%rdi, 0(%rsp)
	movq	0(%rsp), %rax
	addq	$9, %rax
	movq	%rax, 32(%rsp)
	movq	32(%rsp), %rax
	addq	$40, %rsp
	ret
	.size	framed40, .-framed40
	.globl	framed264
	.type	framed264, @function
framed264:                      ;! long(long)
	pushq	%rbp
	movq	%rsp, %rbp
	.byte	0x48,0x81,0xec,0x08,0x01,0x00,0x00  # subq $0x108,%rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	addq	$11, %rax
	movq	%rax, -264(%rbp)    # deepest slot of the byte-sized frame
	movq	-264(%rbp), %rax
	movq	%rbp, %rsp
	popq	%rbp
	ret
	.size	framed264, .-framed264
	.globl	leabytes
	.type	leabytes, @function
leabytes:                       ;! long()
	subq	$408, %rsp
	leaq	-120(%rsp), %rcx   ;! alloca result size=400
	.byte	0x4c,0x8d,0x14,0x24 # leaq (%rsp),%r10 — region-redirected like spelled
	movq	$9, (%r10)
	movq	(%r10), %rax
	addq	$408, %rsp
	ret
	.size	leabytes, .-leabytes
	.section	.note.GNU-stack,"",@progbits
