# Intel-syntax twin of sarcasm-alloca-addq-teardown-att: a branch-free dynamic-alloca
# function whose epilogue teardown `add $imm, %rsp` sits in the SAME straight-line
# region as the `;! alloca result` annotation -- no label separates them. The add is
# honored as a verified teardown (a straight path to `ret` through callee-saved pops),
# not swallowed as alloca machinery; the amount is the correct undo (24 bytes of frame
# + the 96-byte aligned allocation) so plain ground truth matches.
	.intel_syntax noprefix
	.text
	.globl	atd
	.type	atd, @function
atd:                            ;! long()
	endbr64
	push	rbp
	push	rbx
	mov	rbp, rsp
	sub	rsp, 24
	mov	eax, 96            ;! alloca size (b4)
	mov	rcx, rax           # the deferred-idiom size chain
	lea	rdx, [rcx+15]
	and	rdx, -16
	sub	rsp, rdx           # the dynamic allocation: the depth becomes unknown...
	lea	rsi, [rsp+15]
	mov	rdi, rsi
	and	rdi, -16           ;! alloca result (b4)
	mov	QWORD PTR [rbp-24], rdi   # ...but rbp-relative traffic still works through it
	mov	rax, QWORD PTR [rbp-24]
	mov	QWORD PTR [rax], 16909060  # bytes 04 03 02 01 (little-endian)
	movzx	edx, BYTE PTR [rax+1]      # 0x03
	movzx	esi, BYTE PTR [rax+2]      # 0x02
	add	rsi, rdx
	mov	rax, rsi           # return 3 + 2 = 5
	add	rsp, 120           # teardown: undoes `sub 24` + the 96-byte alloca. NO label before this
	pop	rbx                # pairs with the prologue push of %rbx
	pop	rbp                # pairs with the saved frame pointer
	ret
	.size	atd, .-atd
	.section	.note.GNU-stack,"",@progbits
