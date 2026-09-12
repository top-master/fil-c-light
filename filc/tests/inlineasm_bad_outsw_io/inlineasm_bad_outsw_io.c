int main(void)
{
    /* OUTSW outputs a word from memory [RSI] to I/O port in DX. Unsafe: I/O
     * port side effect and implicit memory read. */
    asm volatile("outsw" : : : "rsi", "flags");
    return 0;
}
