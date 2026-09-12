# setcc with a HIGH-byte destination (%ah/%bh): the pin model makes it exact —
# the instruction writes ONLY bits 8-15 of the enclosing register; every other
# bit is preserved (hardware ground truth: rbx=0xAAAAAAAAAAAAAA55 with ZF set
# by the cmp -> sete %bh gives 0xAAAAAAAAAAAA0155).
	.text
	.globl	setcc_hb
	.type	setcc_hb, @function
setcc_hb:                       ;! void(long,ptr)
	endbr64
	movq	$0xAAAAAAAAAAAAAA55, %rbx
	cmpq	$5, %rdi
	sete	%bh
	movq	%rbx, (%rsi)
	movq	$0x1122334455667788, %rax
	cmpq	$6, %rdi
	setne	%ah
	movq	%rax, 8(%rsi)
	movl	$0, %eax
	ret
	.size	setcc_hb, .-setcc_hb
	.section	.note.GNU-stack,"",@progbits
