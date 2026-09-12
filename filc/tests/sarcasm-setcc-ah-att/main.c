#include <stdio.h>

void setcc_hb(unsigned long arg, unsigned long* out);

int main()
{
	unsigned long out[2];
	/* arg=5: cmp 5,5 -> ZF=1 -> sete bh=1; cmp 6,5 -> ZF=0 -> setne ah=1 */
	setcc_hb(5, out);
	if (out[0] != 0xAAAAAAAAAAAA0155UL) {
		printf("sete bh (ZF=1) = %lx, want AAAAAAAAAAAA0155\n", out[0]);
		return 1;
	}
	if (out[1] != 0x1122334455660188UL) {
		printf("setne ah (ZF=0) = %lx, want 1122334455660188\n", out[1]);
		return 1;
	}
	/* arg=6: cmp 5,6 -> ZF=0 -> sete bh=0; cmp 6,6 -> ZF=1 -> setne ah=0 */
	setcc_hb(6, out);
	if (out[0] != 0xAAAAAAAAAAAA0055UL) {
		printf("sete bh (ZF=0) = %lx, want AAAAAAAAAAAA0055\n", out[0]);
		return 1;
	}
	if (out[1] != 0x1122334455660088UL) {
		printf("setne ah (ZF=1) = %lx, want 1122334455660088\n", out[1]);
		return 1;
	}
	printf("setcc-ah att ok\n");
	return 0;
}
