# The md5_block_data_order shape: void(ptr,ptr,size_t) is 5 fast-CC argument
# WORDS (two pointers = 2 words each, the size_t is word 4) — beyond the four
# dense argument registers (rdx,rcx,r8,r9), so the size arrives on the stack in
# the caller's outgoing-args area while the yolo SysV placement wants it in %rdx.
# sarcasm's entry unpack loads it from the incoming stack word. Previously this
# signature was rejected outright (>3 register args / >4 register argument words).
	.text
	.globl	copy5w
	.type	copy5w, @function
copy5w:                         #! void(ptr,ptr,size_t)
	testq	%rdx, %rdx
	je	.Ldone
.Lloop:
	movzbl	(%rsi), %eax
	movb	%al, (%rdi)
	incq	%rsi
	incq	%rdi
	decq	%rdx
	jne	.Lloop
.Ldone:
	ret
	.size	copy5w, .-copy5w
	.section	.note.GNU-stack,"",@progbits
