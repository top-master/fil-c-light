	.text
	.globl	roread
	.type	roread, @function
roread:                         ;! long()
	movl	tab(%rip), %eax
	addl	tab+4(%rip), %eax
	addl	tab+8(%rip), %eax
	addl	tab+12(%rip), %eax
	ret
	.size	roread, .-roread
	.globl	roread2
	.type	roread2, @function
roread2:                        ;! long(long)
	movl	tab+8(%rip), %eax
	addl	tab(%rip), %eax
	addl	msg(%rip), %eax
	movzbl	msg+5(%rip), %ecx
	addl	%ecx, %eax
	ret
	.size	roread2, .-roread2
	.section	.rodata
	.p2align	4
tab:
	.long	10, 20, 30, 40
msg:
	.byte	5
	.zero	4
	.byte	7
	.section	.note.GNU-stack,"",@progbits
