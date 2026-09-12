#include <sys/select.h>
#include <stdfil.h>
#include <stdlib.h>

int main()
{
    // Use a special pointer (zweak_map_new()) as timeout
    select(0, NULL, NULL, NULL, (struct timeval*)zweak_map_new());
    
    return 0;
}
