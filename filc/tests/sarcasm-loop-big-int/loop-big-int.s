# Intel-syntax twin of sarcasm-loop-big-att: `loop` whose back-edge target sits
# beyond rel8 range (6 bounds-checked loads in the body plus the pollcheck at
# the back-edge label), rewritten by sarcasm through a rel8-reachable
# trampoline. Hardware ground truth (plain as + gcc): loopbig(ptr)=66,
# loopbig_rcx(ptr)=0.
	.intel_syntax noprefix
	.text
	.globl	loopbig
	.type	loopbig, @function
loopbig:                        ;! long(ptr)
	endbr64
	mov	rcx, 3
	xor	eax, eax
.Lcount:
	inc	eax
	mov	rsi, QWORD PTR [rdi]
	add	rax, rsi
	mov	rsi, QWORD PTR [rdi + 8]
	add	rax, rsi
	mov	rsi, QWORD PTR [rdi + 16]
	add	rax, rsi
	mov	rsi, QWORD PTR [rdi + 24]
	add	rax, rsi
	mov	rsi, QWORD PTR [rdi + 32]
	add	rax, rsi
	mov	rsi, QWORD PTR [rdi + 40]
	add	rax, rsi
	loop	.Lcount
	ret
	.size	loopbig, .-loopbig
	.globl	loopbig_rcx
	.type	loopbig_rcx, @function
loopbig_rcx:                    ;! long(ptr)
	endbr64
	mov	rcx, 3
	xor	esi, esi
.Ltop:
	add	rsi, QWORD PTR [rdi]
	add	rsi, QWORD PTR [rdi + 8]
	add	rsi, QWORD PTR [rdi + 16]
	add	rsi, QWORD PTR [rdi + 24]
	add	rsi, QWORD PTR [rdi + 32]
	add	rsi, QWORD PTR [rdi + 40]
	loop	.Ltop
	# The modeled decrement must still land in the physical rcx the
	# instruction decrements: 0 after a 3-iteration countdown.
	mov	rax, rcx
	ret
	.size	loopbig_rcx, .-loopbig_rcx
	.section	.note.GNU-stack,"",@progbits
