long foo(void);

/* Never called. This exists so filcc ALSO emits a weak pizlonatedFI2_foo
   callsite resolver in this translation unit, which merges with the assembly
   module's own weak callsite thunk (weak + weak). No strong
   pizlonatedFI2_foo exists anywhere: the data translation unit only provides
   the getter pizlonated_foo, so a weak resolver must win the link. */
long callfoo(void)
{
    return foo();
}
