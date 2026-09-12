# Intel-syntax twin of sarcasm-imm-expr-att: constant-expression immediates
# (`sub rsp, 64+32` — the same OpenSSL perlasm frame idiom, which used to
# silently become a 0-byte frame) and constant-expression displacements, here
# including the Intel-only forms: a leading displacement expression
# (`512-128+8[rdi]`), a constant-product term (`[rdi+256*2]`), and a shift in a
# bracket term (`[rdi+1<<4]` would also work; shiftexpr uses immediates).
	.intel_syntax noprefix
	.text
	.globl	frameexpr
	.type	frameexpr, @function
frameexpr:                      ;! long(long)
	sub	rsp, 64+32
	mov	[rsp+88], rdi
	mov	rax, [rsp+88]
	add	rsp, 64+32
	ret
	.size	frameexpr, .-frameexpr

	.globl	dispexpr_load
	.type	dispexpr_load, @function
dispexpr_load:                  ;! long(ptr)
	mov	eax, 512-128+8[rdi]           # leading constant-expression disp = 392
	ret
	.size	dispexpr_load, .-dispexpr_load

	.globl	dispexpr_store
	.type	dispexpr_store, @function
dispexpr_store:                 ;! void(ptr, long)
	mov	[rdi+256*2], rsi              # constant-product disp = 512
	ret
	.size	dispexpr_store, .-dispexpr_store

	.globl	shiftexpr
	.type	shiftexpr, @function
shiftexpr:                      ;! long()
	mov	rax, 1<<4                     # 16
	add	rax, 2<<3+1                   # 17 (shift binds tighter than +)
	add	rax, 0x10+0x20                # 48: total 81
	ret
	.size	shiftexpr, .-shiftexpr
	.section	.note.GNU-stack,"",@progbits
