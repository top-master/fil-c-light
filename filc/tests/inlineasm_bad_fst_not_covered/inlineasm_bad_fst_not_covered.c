int main(void)
{
    double a = 3.14;
    asm volatile("fst %%st(1)" : "=t"(a) : "0"(a));
    return 0;
}
