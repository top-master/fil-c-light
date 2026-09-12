#include <stdio.h>
#include <stdlib.h>

void idiv_mem_int(long* io, long* divisor_obj);
long idiv_reg_int(long* in, long* out);

int main()
{
    /* Memory-form idiv (QWORD PTR, renders idivq): divisor in the LAST 8
       bytes of a 16-byte object. */
    long* io = malloc(32);
    long* dobj = malloc(16);
    if (!io || !dobj)
        return 1;
    io[0] = 5000000000000L;
    dobj[1] = -999983L;
    idiv_mem_int(io, dobj);
    if (io[1] != io[0] / dobj[1] || io[2] != io[0] % dobj[1]) {
        printf("idiv_mem_int q=%ld r=%ld\n", io[1], io[2]);
        return 1;
    }

    /* Register-form idiv with live webs across cqo/idiv: quotient and
       remainder checked, checksum of the live-across values returned. */
    long* in = malloc(16);
    long* out = malloc(16);
    if (!in || !out)
        return 1;
    long D = -777777777777777777L;
    long S = 99999999L;
    in[0] = D;
    in[1] = S;
    long checksum = idiv_reg_int(in, out);
    if (out[0] != D / S || out[1] != D % S) {
        printf("idiv_reg_int q=%ld r=%ld\n", out[0], out[1]);
        return 1;
    }
    if (checksum != 7 + 70 + 700 + 7000) {
        printf("idiv_reg_int checksum %ld\n", checksum);
        return 1;
    }

    printf("div int ok\n");
    return 0;
}
