#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

void cvtwid_u(void* in, void* out);
void cvtwid_s(void* in, void* out);

int main()
{
    uint32_t* u = malloc(32);
    int32_t* s = malloc(32);
    double* out = malloc(128);
    if (!u || !s || !out)
        return 1;
    u[0] = 0;
    u[1] = 1;
    u[2] = 2;
    u[3] = 4000000000u;      /* > INT32_MAX: catches signed/unsigned confusion */
    u[4] = 4294967295u;
    u[5] = 7;
    u[6] = 8;
    u[7] = 9;
    s[0] = -1;
    s[1] = (-2147483647 - 1);
    s[2] = 42;
    s[3] = -7;
    s[4] = 0;
    s[5] = 1;
    s[6] = 1000000;
    s[7] = -999999;
    cvtwid_u(u, out);
    cvtwid_s(s, out + 8);
    int i;
    for (i = 0; i < 8; i++) {
        if (out[i] != (double)u[i]) {
            printf("u[%d]: got %a want %a\n", i, out[i], (double)u[i]);
            return 1;
        }
        if (out[8 + i] != (double)s[i]) {
            printf("s[%d]: got %a want %a\n", i, out[8 + i], (double)s[i]);
            return 1;
        }
    }
    printf("cvtwid ok\n");
    return 0;
}
