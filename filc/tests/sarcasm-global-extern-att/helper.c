/* The defining module: filcc emits the pizlonated_g getter (and the DO).
   The first `#! global ptr` access from the asm side runs the getter's
   slow path (lazy initialization/registration), and the C initializers
   must be visible. */
int g[4] = { 100, 200, 300, 400 };
