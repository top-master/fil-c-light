int main(void)
{
    double a = 7.5;
    double b = 2.5;
    double result;
    asm volatile("fprem1" : "=u"(result) : "t"(a), "u"(b));
    return 0;
}
