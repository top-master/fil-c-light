int main(void)
{
    unsigned short sw;
    asm volatile("fnstsw %0" : "=m"(sw));
    return 0;
}
