int main(void)
{
    double a = 2.3;
    asm volatile("frndint" : "=t"(a) : "0"(a));
    return 0;
}
