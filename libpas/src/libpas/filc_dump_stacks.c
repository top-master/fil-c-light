/*
 * Copyright (c) 2026 Epic Games, Inc. All Rights Reserved.
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
 * THIS SOFTWARE IS PROVIDED BY EPIC GAMES, INC. ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL EPIC GAMES, INC. OR
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

#include "filc_dump_stacks.h"
#include "filc_runtime.h"

#if PAS_ENABLE_FILC

static pas_lock stacks_dump_lock = PAS_LOCK_INITIALIZER;

void dump_stacks_callback(filc_thread* my_thread, void* arg)
{
    PAS_ASSERT(!arg);
    pas_lock_lock(&stacks_dump_lock);
    pas_log("[%d, %d] thread %p:\n", pas_getpid(), pas_gettid(), my_thread);
    filc_thread_dump_stack(my_thread, pas_log_stream);
    pas_lock_unlock(&stacks_dump_lock);
}

void filc_dump_stacks(void)
{
    filc_soft_handshake(dump_stacks_callback, NULL);
}

#endif /* PAS_ENABLE_FILC */

#endif /* LIBPAS_ENABLED */

