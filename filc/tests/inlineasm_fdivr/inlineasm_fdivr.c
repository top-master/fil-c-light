int main(void)
{
    double a = 2.0;
    double b = 6.0;
    double result;
    asm volatile("fdivrp %%st, %%st(1)" : "=t"(result) : "t"(a), "u"(b)
                 : "fpsr", "st");
    return 0;
}
