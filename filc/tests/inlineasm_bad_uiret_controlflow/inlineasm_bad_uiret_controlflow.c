int main(void)
{
    /* UIRET (User-Interrupt Return) returns from a user-interrupt handler.
       It is unsafe: it is a control flow instruction (return) that pops RIP,
       RFLAGS and possibly a shadow-stack return address from the stack
       (memory access, modifies RSP) and modifies RFLAGS. FilPizlonator must
       reject it. */
    asm volatile("uiret");
    return 0;
}
