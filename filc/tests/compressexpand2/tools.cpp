#include <immintrin.h>

__attribute__((target("avx512f"))) void do_store(__mmask16 mask,
                                                 int* src_data,
                                                 int* compressed_out)
{
    __m512i zmm_src = _mm512_loadu_si512((__m512i*)src_data);
    
    // Compresses the elements from zmm_src where mask=1 and stores them
    _mm512_mask_compressstoreu_epi32(compressed_out, mask, zmm_src);
}

__attribute__((target("avx512f"))) void do_load(__mmask16 mask,
                                                int* compressed_out,
                                                int* expanded_out)
{
    // Loads contiguous elements from compressed_out and scatters them
    // into zmm_dst according to the mask. Unmasked elements are zeroed.
    __m512i zmm_dst = _mm512_maskz_expandloadu_epi32(mask, compressed_out);
    _mm512_storeu_si512((__m512i*)expanded_out, zmm_dst);
}

