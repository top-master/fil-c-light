/*
 * Copyright (c) 2026 Epic Games, Inc. All Rights Reserved.
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

#include "pas_config.h"

#if LIBPAS_ENABLED

#include "filc_dump_heap.h"
#include "filc_runtime_inlines.h"
#include "pas_fd_stream.h"

#if PAS_ENABLE_FILC

/* FIXME: This is mostly copy pasta from the fugc verifier. */

static pas_lock dump_lock = PAS_LOCK_INITIALIZER;
static pas_ptr_hash_set dump_set;
static const char* source_explanation;
static void* source_ptr;
static pas_fd_stream dump_stream;

static bool dump_is_marked(void* mark_base)
{
    return !!pas_ptr_hash_set_find(&dump_set, mark_base);
}

static bool dump_set_is_marked_with_object(void* mark_base, filc_object* target_object)
{
    /* FIXME: This does no buffering. That's probably dumb. */
    pas_fd_stream_printf(&dump_stream, "%s", source_explanation);
    if (source_ptr)
        pas_fd_stream_printf(&dump_stream, "(%p)", source_ptr);
    pas_fd_stream_printf(&dump_stream, "->%p", mark_base);
    if (target_object)
        pas_fd_stream_printf(&dump_stream, "(%p)", target_object);
    pas_fd_stream_printf(&dump_stream, "\n");

    pas_allocation_config allocation_config;
    bmalloc_initialize_allocation_config(&allocation_config);
    return pas_ptr_hash_set_set(&dump_set, mark_base, NULL, &allocation_config);
}

static bool dump_set_is_marked(void* mark_base)
{
    return dump_set_is_marked_with_object(mark_base, NULL);
}

static bool dump_mark(filc_mark_stack* mark_stack, filc_object* object)
{
    if (!object)
        return false;
    uintptr_t aux = object->aux;
    filc_object_flags flags = filc_aux_get_flags(aux);
    if ((flags & FILC_OBJECT_FLAG_GLOBAL))
        return false;
    void* mark_base = filc_object_mark_base_with_flags(object, flags);
    if (!dump_set_is_marked_with_object(mark_base, object))
        return false;
    filc_mark_stack_push(mark_stack, object);
    return true;
}

static void dump_mark_or_free_flight(filc_mark_stack* mark_stack, filc_ptr* ptr)
{
    void* lower = filc_flight_ptr_load_lower(ptr);
    if (!lower)
        return;
    filc_object* object = filc_object_for_lower_not_null(lower);
    dump_mark(mark_stack, object);
}

static void dump_mark_or_free_lower_or_box(filc_mark_stack* mark_stack,
                                             filc_lower_or_box* lower_or_box_ptr)
{
    filc_lower_or_box lower_or_box = filc_lower_or_box_load_unfenced(lower_or_box_ptr);
    if (filc_lower_or_box_is_null(lower_or_box))
        return;
    if (filc_lower_or_box_is_box(lower_or_box)) {
        filc_atomic_box* box = filc_lower_or_box_get_box(lower_or_box);
        dump_set_is_marked(box);
        dump_mark_or_free_flight(mark_stack, &box->ptr);
        return;
    }
    filc_object* object = filc_object_for_lower_not_null(filc_lower_or_box_get_lower(lower_or_box));
    dump_mark(mark_stack, object);
}

#define DUMP_MARKER ((filc_marker){ \
        .mark = dump_mark, \
        .mark_or_free_flight = dump_mark_or_free_flight, \
        .mark_or_free_lower_or_box = dump_mark_or_free_lower_or_box, \
        .is_marked = dump_is_marked, \
        .set_is_marked = dump_set_is_marked, \
        .is_fugc = false \
    })

void filc_dump_heap(int fd)
{
    filc_stop_the_world();
    pas_lock_lock(&dump_lock);
    pas_fd_stream_construct(&dump_stream, fd);
    
    pas_allocation_config allocation_config;
    bmalloc_initialize_allocation_config(&allocation_config);
    pas_ptr_hash_set_construct(&dump_set);
    
    filc_thread** threads;
    size_t num_threads;
    filc_snapshot_threads(&threads, &num_threads);
    
    size_t index;
    /* See https://github.com/pizlonator/fil-c/issues/240 for why we lock the handshake lock. */
    filc_handshake_lock_lock();
    for (index = num_threads; index--;) {
        if (filc_thread_participates_in_pollchecks(threads[index]))
            filc_thread_stop_allocators(threads[index]);
    }
    filc_handshake_lock_unlock();
    
    filc_mark_stack dump_stack;
    filc_mark_stack_construct(&dump_stack);
    
    source_explanation = "global";
    source_ptr = NULL;
    filc_mark_global_roots(DUMP_MARKER, &dump_stack);
    
    for (index = num_threads; index--;) {
        if (filc_thread_participates_in_pollchecks(threads[index])) {
            source_explanation = "thread";
            source_ptr = threads[index];
            filc_thread_mark_roots(threads[index], DUMP_MARKER, &dump_stack);
        }
    }
    
    bmalloc_deallocate(threads);
    
    source_explanation = "object";
    filc_object* object;
    while ((object = filc_mark_stack_pop(&dump_stack))) {
        source_ptr = object;
        filc_object_mark_outgoing_ptrs(object, DUMP_MARKER, &dump_stack);
    }
    
    filc_mark_stack_destruct(&dump_stack);
    pas_ptr_hash_set_destruct(&dump_set, &allocation_config);

    pas_lock_unlock(&dump_lock);
    filc_resume_the_world();
}

#endif /* PAS_ENABLE_FILC */

#endif /* LIBPAS_ENABLED */

