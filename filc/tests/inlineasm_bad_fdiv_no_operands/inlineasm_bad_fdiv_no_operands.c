int main(void)
{
    asm volatile("fdiv" : : : "st", "fpsr");
    return 0;
}
