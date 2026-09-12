#include <sys/time.h>
#include <stdfil.h>
#include <stdio.h>

int main()
{
    struct timeval tv;
    struct timezone tz;
    
    ZASSERT(gettimeofday(&tv, &tz) == 0);
    
    // Verify we got reasonable values
    ZASSERT(tv.tv_sec > 0);
    ZASSERT(tv.tv_usec >= 0);
    ZASSERT(tv.tv_usec < 1000000);
    
    // The timezone values may vary, but should be within reasonable bounds
    ZASSERT(tz.tz_minuteswest >= -720 && tz.tz_minuteswest <= 720); // +/- 12 hours
    ZASSERT(tz.tz_dsttime >= 0 && tz.tz_dsttime <= 10); // DST types
    
    printf("Current time: %ld.%06ld\n", tv.tv_sec, tv.tv_usec);
    printf("Timezone: minuteswest=%d, dsttime=%d\n", tz.tz_minuteswest, tz.tz_dsttime);
    
    return 0;
}