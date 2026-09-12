int main(void)
{
    /* OUTSB outputs a byte from memory [RSI] to I/O port in DX. Unsafe: I/O
     * port side effect and implicit memory read. */
    asm volatile("outsb" : : : "rsi", "flags");
    return 0;
}
