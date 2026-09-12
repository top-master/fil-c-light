#include <stdfil.h>
#include <exception>
#include <string.h>

using namespace std;

void foo();

int main()
{
    bool caught = false;
    try {
        zcall((void*)foo, nullptr);
        ZASSERT(!"Should not be reached");
    } catch (const exception& e) {
        ZASSERT(!strcmp(e.what(), "67"));
        caught = true;
    }
    ZASSERT(caught);
    return 0;
}


