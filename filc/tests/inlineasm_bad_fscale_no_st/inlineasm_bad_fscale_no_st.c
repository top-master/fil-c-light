int main(void)
{
    asm volatile("fscale" : : : "fpsr");
    return 0;
}
