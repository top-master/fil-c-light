int main(void)
{
    asm volatile("fsin" : : : "fpsr");
    return 0;
}
