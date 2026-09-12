# The x86_64-mont shape: a DYNAMIC alloca region (register-computed size) whose
# buffer is reached by DIRECT fixed-offset and INDEXED rsp-relative traffic in
# the alloca's dynamic scope, plus the phantom saved-rsp carrier parked in the
# region and recovered through a reload (the aes/mont epilogue idiom).
# region base = rsp - 64 (the `leaq -64(%rsp)` result, bias 64), size = 8*n+128.
	.text
	.globl	dynalloca_like
	.type	dynalloca_like, @function
dynalloca_like:                 #! long(ptr,long)
	movq	%rsp, %rax          # prologue rsp save (phantom carrier)
	pushq	%rbx
	pushq	%r12
	pushq	%r13
	leaq	128(,%rsi,8), %r10  # r10 = 8*n + 128 = the region size (dynamic)
	subq	%r10, %rsp          #! alloca size (dyn)
	leaq	-64(%rsp), %r10     #! alloca result (dyn)
	movq	%rax, -64(%rsp)     # carrier save-store into region slot 0
	xorq	%rbx, %rbx          # i = 0
	xorq	%r12, %r12          # acc = 0
.Ldynloop:
	movq	%rbx, %r13
	imulq	%rbx, %r13
	movq	%r13, -56(%rsp,%rbx,8)  # INDEXED region write: region[8 + 8*i] = i*i
	addq	%r13, %r12
	leaq	1(%rbx), %rbx
	cmpq	%rsi, %rbx
	jne	.Ldynloop
	xorq	%rbx, %rbx
	xorq	%r13, %r13
.Ldyncheck:
	addq	-56(%rsp,%rbx,8), %r13  # INDEXED region read
	leaq	1(%rbx), %rbx
	cmpq	%rsi, %rbx
	jne	.Ldyncheck
	cmpq	%r12, %r13
	jne	.Ldynbad
	movq	%r12, %rax          # result = sum of i*i (before the restores)
	jmp	.Ldynepi
.Ldynbad:
	movq	$-1, %rax
.Ldynepi:
	movq	-64(%rsp), %rsi     # carrier reload from region slot 0
	movq	-24(%rsi), %r13     # epilogue restore loads through the carrier
	movq	-16(%rsi), %r12
	movq	-8(%rsi), %rbx
	leaq	(%rsi), %rsp        # rsp recovery from the carrier
	ret
	.size	dynalloca_like, .-dynalloca_like
	.section	.note.GNU-stack,"",@progbits
