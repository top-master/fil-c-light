int main(void)
{
    double a = 4.0;
    asm volatile("fsqrt" : "=t"(a) : "0"(a));
    return 0;
}
