#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

void masked_alu_ops(uint64_t* q, long mask);
void masked_alu_oob(uint64_t* q);

int main()
{
	uint64_t* q = calloc(8, sizeof(uint64_t));
	if (!q)
		return 1;
	q[0] = 10; q[1] = 20; q[2] = 30; q[3] = 40;
	q[4] = 100; q[5] = 200; q[6] = 300; q[7] = 400;
	/* mask 0101: lanes 0 and 2 enabled */
	masked_alu_ops(q, 5);
	int fails = 0;
	/* vpsubq: q0 = 10-100, q2 = 30-300; lanes 1,3 preserved */
	if ((int64_t)q[0] != -90 || q[1] != 20 || (int64_t)q[2] != -270 || q[3] != 40) {
		printf("vpsubq masked: %ld %ld %ld %ld\n",
			(int64_t)q[0], (int64_t)q[1], (int64_t)q[2], (int64_t)q[3]);
		fails = 1;
	}
	/* vpxorq {z}: q4 = 100^10, q6 = 300^30; lanes 1,3 zeroed */
	if (q[4] != (100 ^ 10) || q[5] != 0 || q[6] != (300 ^ 30) || q[7] != 0) {
		printf("vpxorq masked-z: %lu %lu %lu %lu\n", q[4], q[5], q[6], q[7]);
		fails = 1;
	}
	free(q);
	/* OOB masked-off lanes: a 5-qword object, mask 0001 (only lane 0 read) */
	uint64_t* r = calloc(5, sizeof(uint64_t));
	if (!r)
		return 1;
	r[0] = 1000; r[1] = 2000; r[2] = 3000; r[3] = 4000; r[4] = 7;
	masked_alu_oob(r);
	if (r[0] != 1000 - 7 || r[1] != 2000 || r[2] != 3000 || r[3] != 4000) {
		printf("vpsubq oob-lane: %lu %lu %lu %lu\n", r[0], r[1], r[2], r[3]);
		fails = 1;
	}
	free(r);
	if (fails)
		return 1;
	printf("masked-alu att ok\n");
	return 0;
}
