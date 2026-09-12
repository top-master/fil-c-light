int main(void)
{
    double a = 3.0;
    double b = 2.0;
    double result;
    asm volatile("fmulp %%st, %%st(1)" : "=t"(result) : "t"(a), "u"(b)
                 : "fpsr", "st");
    return 0;
}
