# B1 tail branch with STACK ARGUMENTS (the aesni_multi_cbc_encrypt shape):
# a 7-argument dispatcher tail-branches to a 7-argument variant. The 7th
# argument travels on the stack; the call conversion marshals it from the
# dispatcher's own incoming stack-argument slot (a hardware `jmp` passes it
# through in place).
	.text
	.globl	multi_dispatch
	.type	multi_dispatch, @function
multi_dispatch:                 ;! long(long,long,long,long,long,long,long)
	testl	%edi, %edi
	jnz	multi_variant
	# fallthrough: sum all seven args
	leaq	(%rdi,%rsi), %rax
	addq	%rdx, %rax
	addq	%rcx, %rax
	addq	%r8, %rax
	addq	%r9, %rax
	addq	8(%rsp), %rax
	ret
	.size	multi_dispatch, .-multi_dispatch
	.type	multi_variant, @function
multi_variant:                  ;! long(long,long,long,long,long,long,long)
	# product of all seven args
	movq	%rdi, %rax
	imulq	%rsi, %rax
	imulq	%rdx, %rax
	imulq	%rcx, %rax
	imulq	%r8, %rax
	imulq	%r9, %rax
	imulq	8(%rsp), %rax
	ret
	.size	multi_variant, .-multi_variant
	.section	.note.GNU-stack,"",@progbits
