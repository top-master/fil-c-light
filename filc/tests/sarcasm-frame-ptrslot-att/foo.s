	.text
	.globl	id
	.type	id, @function
id:                             ;! long(long)
	movq	%rdi, %rax
	ret
	.size	id, .-id
	.globl	foo
	.type	foo, @function
foo:                            ;! long(ptr, long)
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -8(%rbp)      # the pointer argument, spilled through an rbp-relative slot
	movl	%esi, -16(%rbp)     # v, through another slot
	movq	$0, %rdi            # clobber the argument register: the slot now holds the only copy
	movl	$7, %edi
	call	id                  ;! long(long)    # safepoint while the pointer lives only in the slot
	movq	-8(%rbp), %rax      # reload the pointer from the slot
	movl	-16(%rbp), %ecx     # reload v
	movb	%cl, (%rax)         # write through the reloaded pointer
	movsbl	(%rax), %edx        # read through the reloaded pointer
	movq	%rax, 16(%rsp)      # park the pointer in an rsp-relative slot
	movl	%edx, 24(%rsp)      # park the byte read
	movq	16(%rsp), %rdi      # reload the pointer from the rsp-relative slot
	movl	$33, %esi
	call	foo2                ;! void(ptr)     # writes '!' at buf[0]
	movq	16(%rsp), %rax      # reload the pointer once more
	movsbl	(%rax), %edx        # read -> 33
	movl	24(%rsp), %eax      # the parked byte -> 42
	addl	%edx, %eax          # 75
	addl	-16(%rbp), %eax     # + v -> 117
	leaq	-48(%rbp), %rsp
	leave
	ret
	.size	foo, .-foo
	.globl	foo2
	.type	foo2, @function
foo2:                           ;! void(ptr)
	movq	%rdi, %rax
	movb	$33, (%rax)
	ret
	.size	foo2, .-foo2
	.section	.note.GNU-stack,"",@progbits
