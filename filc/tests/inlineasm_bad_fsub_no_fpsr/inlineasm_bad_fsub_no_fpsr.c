int main(void)
{
    double a = 5.0;
    double b = 2.0;
    double result;
    asm volatile("fsub %%st(1), %%st" : "=t"(result) : "0"(a), "u"(b));
    return 0;
}
