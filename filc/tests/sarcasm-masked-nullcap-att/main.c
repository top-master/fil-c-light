#include <stdio.h>

void f(void* p, long k);

int main()
{
    printf("setup ok\n");
    /* A masked load with mask == 0 through a NULL capability must still trap:
       ValidObject fires even when no lane would be accessed. */
    f((void*)0, 0);
    printf("SHOULD NOT PRINT\n");
    return 0;
}
