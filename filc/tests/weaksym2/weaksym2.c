#include <stdfil.h>
#include "utils.h"

void __attribute__((weak)) foo();
extern int __attribute__((weak)) bar;
extern __thread int __attribute__((weak)) baz;

int main()
{
    if (foo) {
        zprintf("seem to have foo\n");
        foo();
    } else
        zprintf("did not find foo\n");
    if (&bar) {
        zprintf("seem to have bar\n");
        zprintf("bar = %d\n", bar);
    } else
        zprintf("did not find bar\n");
    /* FIXME: llvm seems to assume that threadlocals cannot be null, even if they're weak. That's
       actually a correct assumption for Yolo-C, but not for Fil-C. */
    if (opaque(&baz)) {
        zprintf("seem to have baz\n");
        zprintf("baz = %d\n", baz);
    } else
        zprintf("did not find baz\n");
    return 0;
}

