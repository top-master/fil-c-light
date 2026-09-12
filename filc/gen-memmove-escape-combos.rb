#!/usr/bin/env ruby

puts "#include <filc_test_support.h>"
puts "#include \"utils.h\""

testCount = 0

kinds = [:localNaked, :localExplicit, :escaping]
kinds.each {
    | dstKind |
    kinds.each {
        | srcKind |
        [32, 128].each {
            | size |
            puts "static void test#{testCount}(void)"
            puts "{"
            puts "    char dst[#{size}];"
            puts "    char src[#{size}];"
            if dstKind == :escaping
                puts "    opaque(dst);"
            end
            if srcKind == :escaping
                puts "    opaque(src);"
            end
            if srcKind == :localNaked
                size.times {
                    | index |
                    puts "    src[#{index}] = #{index};"
                }
            else
                puts "    unsigned src_index;"
                puts "    for (src_index = (unsigned)opaque(0); "
                puts "         src_index < (unsigned)opaque((void*)#{size});"
                puts "         ++src_index)"
                puts "        src[src_index] = src_index;"
            end
            puts "    zmemmove_builtin(dst, src, #{size});"
            if dstKind == :localNaked
                size.times {
                    | index |
                    puts "    ZASSERT(dst[#{index}] == #{index});"
                }
            else
                puts "    unsigned dst_index;"
                puts "    for (dst_index = (unsigned)opaque(0); "
                puts "         dst_index < (unsigned)opaque((void*)#{size});"
                puts "         ++dst_index)"
                puts "        ZASSERT(dst[dst_index] == dst_index);"
            end
            puts "}"
            testCount += 1
        }
    }
}

puts "int main()"
puts "{"
testCount.times {
    | index |
    puts "    test#{index}();"
}
puts "    return 0;"
puts "}"


