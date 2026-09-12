int main(void)
{
    double a = 1.0;
    asm volatile("fsin" : "=t"(a) : "0"(a));
    return 0;
}
