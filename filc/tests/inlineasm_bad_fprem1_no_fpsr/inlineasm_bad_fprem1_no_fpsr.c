int main(void)
{
    double a = 7.5;
    double b = 2.5;
    double result;
    asm volatile("fprem1" : "=t"(result) : "0"(a), "u"(b));
    return 0;
}
