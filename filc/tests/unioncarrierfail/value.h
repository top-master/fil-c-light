#ifndef UNION_CARRIER_FAIL_VALUE_H
#define UNION_CARRIER_FAIL_VALUE_H

union Hidden { unsigned long bits; int *pointers[1]; };
union Hidden bounce(union Hidden value);

#endif
