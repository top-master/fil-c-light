# Taking the address INSIDE a fixed alloca region (`leaq 32(%rsp), %rdi`) is
# redirected to region-pointer arithmetic — a real pointer into the GC region
# that a C helper may write through (the ghash/ecp shape of handing a frame
# buffer to a subroutine).
	.text
	.globl	leaaddr
	.type	leaaddr, @function
leaaddr:                        ;! long()
	subq	$136, %rsp
	movq	%rsp, %rbx          ;! alloca result size=128
	leaq	32(%rsp), %rdi      # address of the region's second quarter
	call	fill32 ;! void(ptr)
	leaq	64(%rsp), %rdi
	call	fill32 ;! void(ptr)
	movq	32(%rbx), %rax      # sum what the helper wrote
	addq	40(%rbx), %rax
	addq	64(%rbx), %rax
	addq	72(%rbx), %rax
	addq	$136, %rsp
	ret
	.size	leaaddr, .-leaaddr
	.section	.note.GNU-stack,"",@progbits
