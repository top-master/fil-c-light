int main(void)
{
    asm volatile("fmul" : : : "st", "fpsr");
    return 0;
}
