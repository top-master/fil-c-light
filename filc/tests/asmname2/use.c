void bar(int) asm("foo");

void foo(int);

int main()
{
    foo(0);
    bar(1);
    return 0;
}


