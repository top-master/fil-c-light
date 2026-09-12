int main(void)
{
    double a = 1.0;
    asm volatile("fnop %0" : "=t"(a) : "0"(a));
    return 0;
}
