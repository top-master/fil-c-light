# The x25519 fe64 / aes AES_set_decrypt_key shape: a prologue push of a
# CALLER-SAVED register used as a SPILL (park an argument across scratch use
# of the register), reloaded later by an ordinary load. The push virtualizes
# as a slot store; the reload reads the slot web.
	.text
	.globl	spill_like
	.type	spill_like, @function
spill_like:                     #! long(ptr,long)
	pushq	%rbp
	pushq	%rbx
	pushq	%r12
	pushq	%r13
	pushq	%r14
	pushq	%r15
	pushq	%rdi                # SPILL push: park the pointer argument
	leaq	-16(%rsp), %rsp     # constant frame
	movq	%rsi, %rdi          # scratch use of rdi (redefines it)
	imulq	%rdi, %rdi
	movq	%rdi, %r12          # r12 = arg2 * arg2
	movq	16(%rsp), %rdi      # RELOAD the spilled pointer (slot 16)
	movq	(%rdi), %rax        # deref the parked pointer
	addq	%r12, %rax
	movq	24(%rsp), %r15      # epilogue restore loads
	movq	32(%rsp), %r14
	movq	40(%rsp), %r13
	movq	48(%rsp), %r12
	movq	56(%rsp), %rbx
	movq	64(%rsp), %rbp
	leaq	72(%rsp), %rsp      # frame teardown
	ret
	.size	spill_like, .-spill_like
	.section	.note.GNU-stack,"",@progbits
