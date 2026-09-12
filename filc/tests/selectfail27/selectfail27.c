#include <sys/select.h>
#include <stdfil.h>
#include <stdlib.h>

int main()
{
    struct timeval timeout;
    timeout.tv_sec = 0;
    timeout.tv_usec = 0;
    
    // Pass a pointer that starts in bounds but will go out of bounds
    // struct timeval is 16 bytes, so offset by 8 to have only 8 bytes remaining
    select(0, NULL, NULL, NULL, (struct timeval*)((char*)&timeout + 8));
    
    return 0;
}
