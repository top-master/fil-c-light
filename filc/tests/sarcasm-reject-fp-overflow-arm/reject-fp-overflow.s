/* Nine double arguments: the arm64 fast CC only has the eight vector registers
   v0..v7 for FP arguments (sarcasm does not marshal stack arguments), so a
   signature with more than 8 FP args is rejected. */
	.text
	.global	f9
	.type	f9, %function
f9:                             ;! double(double, double, double, double, double, double, double, double, double)
	ret
	.size	f9, .-f9
