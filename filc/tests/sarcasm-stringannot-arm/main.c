#include <stdio.h>

/* Proves the string-aware marker scan on arm64: if any in-string `//!`/`;!`
   fabricated an annotation, the .s file would fail to compile. The printed
   strings mirror the .s payloads byte for byte (backslash-for-backslash, so
   the escaped-quote payloads print their `\"`). */
long echo_first(long* p);

int main()
{
    long v = 7;
    printf("stringannot arm ok %ld\n", echo_first(&v));
    printf("a //! b\n");
    printf("a ;! b\n");
    printf("a #! b\n");
    printf("x //! y ;! z\n");
    printf("trailing marker ;!\n");
    printf("//! at start ;! in middle #! at end\n");
    printf("a \\\" ;! b\n");
    printf("a \\\" //! b\n");
    printf("a \\\" // x\n");
    printf("a\\\\b ;! x\n");
    return 0;
}
