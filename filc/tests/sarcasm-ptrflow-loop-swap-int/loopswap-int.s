# Intel-syntax twin of the ptrflow loop-swap widening shape (see the -att test).
	.intel_syntax noprefix
	.text
	.globl	loop_swap_ptr
	.type	loop_swap_ptr, @function
loop_swap_ptr:                  ;! void(ptr,ptr,long)
	mov	rcx, rdx
.Lloop:
	mov	rax, QWORD PTR [rsi]  # read a[i] (iter 1) then out[i] (later iters)
	mov	QWORD PTR [rdi], rax  # write out[i]  -- must use out's capability
	add	rsi, 8
	add	rdi, 8
	mov	rsi, rdi              # swap: out -> inp (loop-carried pointer swap)
	sub	rcx, 1
	jnz	.Lloop
	ret
	.size	loop_swap_ptr, .-loop_swap_ptr
	.section	.note.GNU-stack,"",@progbits
