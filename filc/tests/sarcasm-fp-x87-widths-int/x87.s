	.intel_syntax noprefix
	.text
	.globl	x87_dbl_roundtrip
	.type	x87_dbl_roundtrip, @function
x87_dbl_roundtrip:              ;! void(ptr, ptr)
	# fld QWORD PTR renders fldl: a full 8-byte double load (a 4-byte flds
	# load of 3.5's zero low half would yield 0.0). fstp QWORD PTR renders
	# fstpl and stores all 8 bytes byte-exact.
	fld	QWORD PTR [rdi]
	fstp	QWORD PTR [rsi]
	ret
	.size	x87_dbl_roundtrip, .-x87_dbl_roundtrip
	.globl	x87_i64_roundtrip
	.type	x87_i64_roundtrip, @function
x87_i64_roundtrip:              ;! void(ptr, ptr)
	# fild QWORD PTR renders fildq: a full 8-byte int64 load (a 2-byte filds
	# load would truncate 2^53+1 to 1). fistp QWORD PTR renders fistpq.
	fild	QWORD PTR [rdi]
	fistp	QWORD PTR [rsi]
	ret
	.size	x87_i64_roundtrip, .-x87_i64_roundtrip
	.globl	x87_tbyte_roundtrip
	.type	x87_tbyte_roundtrip, @function
x87_tbyte_roundtrip:            ;! void(ptr, ptr)
	# fld/fstp TBYTE PTR render fldt/fstpt: 10-byte extended round-trip.
	fld	TBYTE PTR [rdi]
	fstp	TBYTE PTR [rsi]
	ret
	.size	x87_tbyte_roundtrip, .-x87_tbyte_roundtrip
	.section	.note.GNU-stack,"",@progbits
