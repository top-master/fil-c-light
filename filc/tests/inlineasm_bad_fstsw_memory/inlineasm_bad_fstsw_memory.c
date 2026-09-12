int main(void)
{
    unsigned short sw;
    asm volatile("fstsw %0" : "=m"(sw));
    return 0;
}
