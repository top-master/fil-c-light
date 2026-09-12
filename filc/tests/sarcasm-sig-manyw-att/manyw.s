# A 6-argument mixed ptr/int signature: void(ptr,ptr,size_t,ptr,ptr,int) is TEN
# fast-CC argument words (2+2+1+2+2+1) — words 4..9 arrive on the stack. Every
# argument is consumed so the test proves each one landed in its yolo SysV
# register (rdi,rsi,rdx,rcx,r8,r9 respectively): the pointers get ordinary
# (bounds-checked) loads, the ints are summed in.
	.text
	.globl	sum6w
	.type	sum6w, @function
sum6w:                          #! long(ptr,ptr,size_t,ptr,ptr,int)
	movq	(%rdi), %rax
	addq	(%rsi), %rax
	addq	%rdx, %rax
	addq	(%rcx), %rax
	addq	(%r8), %rax
	movl	%r9d, %ecx
	addq	%rcx, %rax
	ret
	.size	sum6w, .-sum6w
	.section	.note.GNU-stack,"",@progbits
