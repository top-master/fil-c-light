int main(void)
{
    double a = 3.14;
    double b;
    asm volatile("fst %%st(0)" : "=u"(b) : "t"(a));
    return 0;
}
