/*
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

#ifndef VERSE_LOCAL_ALLOCATOR_H
#define VERSE_LOCAL_ALLOCATOR_H

#include "pas_local_allocator.h"
#include "verse_heap_config.h"

#if PAS_ENABLE_VERSE

PAS_BEGIN_EXTERN_C;

typedef struct pas_heap pas_heap;

#define VERSE_SMALL_SEGREGATED_LOCAL_ALLOCATOR_SIZE PAS_LOCAL_ALLOCATOR_SIZE(VERSE_HEAP_SMALL_SEGREGATED_PAGE_SIZE >> VERSE_HEAP_SMALL_SEGREGATED_MIN_ALIGN_SHIFT)
#define VERSE_MEDIUM_SEGREGATED_LOCAL_ALLOCATOR_SIZE PAS_LOCAL_ALLOCATOR_SIZE(VERSE_HEAP_MEDIUM_SEGREGATED_PAGE_SIZE >> VERSE_HEAP_MEDIUM_SEGREGATED_MIN_ALIGN_SHIFT)
#define VERSE_MAX_SEGREGATED_LOCAL_ALLOCATOR_SIZE ( \
    VERSE_SMALL_SEGREGATED_LOCAL_ALLOCATOR_SIZE > VERSE_MEDIUM_SEGREGATED_LOCAL_ALLOCATOR_SIZE \
    ? VERSE_SMALL_SEGREGATED_LOCAL_ALLOCATOR_SIZE : VERSE_MEDIUM_SEGREGATED_LOCAL_ALLOCATOR_SIZE)

PAS_API void verse_local_allocator_construct(pas_local_allocator* allocator, pas_heap* heap, size_t object_size, size_t allocator_size);
PAS_API void verse_local_allocator_stop(pas_local_allocator* allocator);
void* verse_local_allocator_allocate(pas_local_allocator* allocator);
PAS_API void* verse_local_allocator_try_allocate(pas_local_allocator* allocator);
    
PAS_END_EXTERN_C;

#endif /* PAS_ENABLE_VERSE */

#endif /* VERSE_LOCAL_ALLOCATOR_H */

