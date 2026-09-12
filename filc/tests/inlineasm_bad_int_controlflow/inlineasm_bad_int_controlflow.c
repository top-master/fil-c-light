int main(void)
{
    /* INT n is a software interrupt: it pushes EFLAGS, CS and the return
       address onto the stack (a memory access) and transfers control to the
       interrupt/exception handler selected by the immediate vector in the
       IDT (a control-flow transfer / kernel trap, e.g. int $0x80 is the
       legacy Linux system-call trap). Unsafe on multiple grounds, so
       FilPizlonator must reject it. */
    asm volatile("int $0x80");
    return 0;
}
