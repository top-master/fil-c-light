/* Test if we still report stack overflow error even though we're teasing the compiler to do some
   stupid UB optimization. */
static void foo(void) { foo(); }
int main() { foo(); return 0; }
