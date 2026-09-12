/* The asm dispatcher reads OPENSSL_ia32cap_P+8 via `#! global ptr`. Zero means
   "no ADX/BMI2": the runtime dispatch always takes the plain-mulq path (the
   AVX/mulx clone is still compiled into the function — that combination is the
   register-saturated shape that used to fail register allocation). */
unsigned int OPENSSL_ia32cap_P[4] = { 0, 0, 0, 0 };
/* pressmin.s's dispatcher reads feat[0] the same way (0 -> plain-mulq path). */
unsigned int feat[4] = { 0, 0, 0, 0 };
