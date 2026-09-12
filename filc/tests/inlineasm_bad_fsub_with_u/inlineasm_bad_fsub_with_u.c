int main(void)
{
    double a = 5.0;
    double b = 2.0;
    double result;
    asm volatile("fsub %%st(1), %%st" : "=u"(result) : "t"(a), "u"(b) : "fpsr");
    return 0;
}
