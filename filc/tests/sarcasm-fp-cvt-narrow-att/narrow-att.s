	.text
	.globl	cvt_narrow_x_att
	.type	cvt_narrow_x_att, @function
cvt_narrow_x_att:               ;! void(ptr, ptr)
	# vcvtpd2psx: the AT&T x source suffix drives an exact 16-byte width.
	# rdi -> 16-byte object holding two doubles (the 16-byte checked load
	# fills the object exactly; a wider width model would trap).
	# rsi -> float[4] out.
	vcvtpd2psx	(%rdi), %xmm0
	vmovups	%xmm0, (%rsi)
	ret
	.size	cvt_narrow_x_att, .-cvt_narrow_x_att

	.globl	cvt_narrow_y_att
	.type	cvt_narrow_y_att, @function
cvt_narrow_y_att:               ;! void(ptr, ptr)
	# vcvtpd2psy: the y source suffix drives an exact 32-byte width.
	# rdi -> 32-byte object holding four doubles; rsi -> float[4] out.
	vcvtpd2psy	(%rdi), %xmm0
	vmovups	%xmm0, (%rsi)
	ret
	.size	cvt_narrow_y_att, .-cvt_narrow_y_att

	.globl	cvt_narrow_z_att
	.type	cvt_narrow_z_att, @function
cvt_narrow_z_att:               ;! void(ptr, ptr)
	# Bare unsized vcvtpd2ps with a ymm destination: unambiguous (the only
	# encodable source is m512), so the 64-byte load is accepted and checked
	# at exactly 64 bytes. rdi -> 64-byte object holding eight doubles;
	# rsi -> float[8] out.
	vcvtpd2ps	(%rdi), %ymm0
	vmovups	%ymm0, (%rsi)
	ret
	.size	cvt_narrow_z_att, .-cvt_narrow_z_att
	.section	.note.GNU-stack,"",@progbits
