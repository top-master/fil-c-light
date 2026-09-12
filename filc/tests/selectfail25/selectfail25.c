#include <sys/select.h>
#include <stdfil.h>
#include <stdlib.h>

int main()
{
    struct timeval timeout;
    timeout.tv_sec = 0;
    timeout.tv_usec = 0;
    
    // Pass a pointer that is 1000 bytes above the bounds of timeout
    select(0, NULL, NULL, NULL, (struct timeval*)((char*)&timeout + 1000));
    
    return 0;
}
