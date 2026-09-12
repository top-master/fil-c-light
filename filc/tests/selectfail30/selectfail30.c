#include <sys/select.h>
#include <stdfil.h>
#include <stdlib.h>
#include <inttypes.h>

int main()
{
    // Use an integer cast to pointer as timeout
    select(0, NULL, NULL, NULL, (struct timeval*)0x1010101010101010UL);
    
    return 0;
}
