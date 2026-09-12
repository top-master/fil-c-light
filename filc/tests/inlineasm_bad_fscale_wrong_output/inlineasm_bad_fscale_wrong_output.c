int main(void)
{
    double a = 1.5;
    double b = 3.0;
    double result;
    asm volatile("fscale" : "=u"(result) : "t"(a), "u"(b));
    return 0;
}
