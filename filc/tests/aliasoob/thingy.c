int foo(void) { return 42; }

asm(".filc_alias foo + 666, foo666");
