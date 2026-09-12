int main(void)
{
    asm volatile("fcos" : : : "fpsr");
    return 0;
}
