cmake_minimum_required(VERSION 2.8)
project(asm_test C ASM)

add_executable(test_asm src/asm_functions.S src/asm_mod_array.s src/test_asm.c)

install(TARGETS test_asm RUNTIME DESTINATION bin LIBRARY DESTINATION lib ARCHIVE DESTINATION lib)
