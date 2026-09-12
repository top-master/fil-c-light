#include <stdio.h>

long dotalloca_save(void);

int main(void)
{
    if (dotalloca_save() != 1) {
        printf("FAIL save\n");
        return 1;
    }
    printf("dotalloca save ok\n");
    return 0;
}
