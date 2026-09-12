/*
 * Copyright (c) 2023 Epic Games, Inc. All Rights Reserved.
 * Copyright (c) 2026 Filip Pizlo. All Rights Reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY FILIP PIZLO ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL FILIP PIZLO OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
 */

#ifndef VERSE_HEAP_ITERATE_FILTER_H
#define VERSE_HEAP_ITERATE_FILTER_H

#include "pas_utils.h"

#if PAS_ENABLE_VERSE

PAS_BEGIN_EXTERN_C;

enum verse_heap_iterate_filter {
    /* Iterate unmarked objects.

       Sample uses:
       - Destructing dead objects before sweep.
       - Executing fixpoint constraints on objects that can self-mark during the mark phase. */
    verse_heap_iterate_unmarked,

    /* Iterate marked objects.

       Sample uses:
       - Performing a census post-mark but pre-sweep, for example to null weak references.
       - Executing fixpoint constraints on objects whose constraints become live when those objects are
         live. */
    verse_heap_iterate_marked,
};

typedef enum verse_heap_iterate_filter verse_heap_iterate_filter;

static inline const char* verse_heap_iterate_filter_get_string(verse_heap_iterate_filter filter)
{
    switch (filter) {
    case verse_heap_iterate_unmarked:
        return "unmarked";
    case verse_heap_iterate_marked:
        return "marked";
    }
    PAS_ASSERT(!"Should not be reached");
    return NULL;
}

PAS_END_EXTERN_C;

#endif /* PAS_ENABLE_VERSE */

#endif /* VERSE_HEAP_ITERATE_FILTER_H */

