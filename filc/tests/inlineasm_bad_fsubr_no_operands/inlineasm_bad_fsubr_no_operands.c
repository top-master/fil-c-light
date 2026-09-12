int main(void)
{
    asm volatile("fsubr" : : : "st", "fpsr");
    return 0;
}
