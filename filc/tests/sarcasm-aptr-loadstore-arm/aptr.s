/* Atomic pointer load/store through sarcasm's `;! atomic load ptr` /
   `;! atomic store ptr` (runtime-call based), in the plain ldr/str forms
   (with and without offsets, incl. the unscaled ldur/stur), the acquire
   ldar/ldapr and release stlr forms, and the plain `;! load ptr` /
   `;! store ptr` forms for interop. Every loaded pointer keeps its
   capability (the C driver dereferences each one). */

	.arch_extension lse
	.text

	.globl	ap_store
	.type	ap_store, %function
ap_store:                       ;! void(ptr, ptr)
	str	x1, [x0]        ;! atomic store ptr
	ret
	.size	ap_store, .-ap_store

	.globl	ap_load
	.type	ap_load, %function
ap_load:                        ;! ptr(ptr)
	ldr	x0, [x0]        ;! atomic load ptr
	ret
	.size	ap_load, .-ap_load

	.globl	p_store
	.type	p_store, %function
p_store:                        ;! void(ptr, ptr)
	str	x1, [x0]        ;! store ptr
	ret
	.size	p_store, .-p_store

	.globl	p_load
	.type	p_load, %function
p_load:                         ;! ptr(ptr)
	ldr	x0, [x0]        ;! load ptr
	ret
	.size	p_load, .-p_load

	.globl	ap_store_rel
	.type	ap_store_rel, %function
ap_store_rel:                   ;! void(ptr, ptr)
	stlr	x1, [x0]        ;! atomic store ptr
	ret
	.size	ap_store_rel, .-ap_store_rel

	.globl	ap_load_acq
	.type	ap_load_acq, %function
ap_load_acq:                    ;! ptr(ptr)
	ldar	x0, [x0]        ;! atomic load ptr
	ret
	.size	ap_load_acq, .-ap_load_acq

	.globl	ap_load_apr
	.type	ap_load_apr, %function
ap_load_apr:                    ;! ptr(ptr)
	ldapr	x0, [x0]        ;! atomic load ptr
	ret
	.size	ap_load_apr, .-ap_load_apr

	.globl	ap_store_off
	.type	ap_store_off, %function
ap_store_off:                   ;! void(ptr, ptr)
	# offset form: stores slot[1]
	str	x1, [x0, #8]    ;! atomic store ptr
	ret
	.size	ap_store_off, .-ap_store_off

	.globl	ap_load_off
	.type	ap_load_off, %function
ap_load_off:                    ;! ptr(ptr)
	# offset form: loads slot[1]
	ldr	x0, [x0, #8]    ;! atomic load ptr
	ret
	.size	ap_load_off, .-ap_load_off

	.globl	ap_store_uns
	.type	ap_store_uns, %function
ap_store_uns:                   ;! void(ptr, ptr)
	# unscaled negative-offset form: given &slot[1], stores slot[0]
	stur	x1, [x0, #-8]   ;! atomic store ptr
	ret
	.size	ap_store_uns, .-ap_store_uns

	.globl	ap_load_uns
	.type	ap_load_uns, %function
ap_load_uns:                    ;! ptr(ptr)
	# unscaled negative-offset form: given &slot[1], loads slot[0]
	ldur	x0, [x0, #-8]   ;! atomic load ptr
	ret
	.size	ap_load_uns, .-ap_load_uns

	.section	.note.GNU-stack,"",@progbits
