int main(void)
{
    asm volatile("fchs" : : : "fpsr");
    return 0;
}
