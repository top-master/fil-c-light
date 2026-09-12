int main(void)
{
    /* OUTSD outputs a doubleword from memory [RSI] to I/O port in DX. Unsafe:
     * I/O port side effect and implicit memory read. */
    asm volatile("outsd" : : : "rsi", "flags");
    return 0;
}
