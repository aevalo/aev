cmake_minimum_required(VERSION 2.8)
project(dynlib CXX)

include_directories("${CMAKE_CURRENT_SOURCE_DIR}/src")

set(dynlib_HDRS src/dynlib.hpp)
if(WIN32)
  set(dynlib_SRCS src/dynlib_win32.cpp)
  set(dynlib_LIBS kernel32)
else(WIN32)
  set(dynlib_SRCS src/dynlib_unix.cpp)
  set(dynlib_LIBS dl)
endif(WIN32)

add_library(dynlib STATIC ${dynlib_HDRS} ${dynlib_SRCS})
target_link_libraries(dynlib ${dynlib_LIBS})

set_target_properties(dynlib PROPERTIES
  PUBLIC_HEADER ${dynlib_HDRS}
  DEBUG_POSTFIX "d")

add_executable(dynloader src/main.cpp)
target_link_libraries(dynloader dynlib)

add_dependencies(dynloader dynlib)

install(TARGETS dynlib dynloader
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  PUBLIC_HEADER DESTINATION include/dynlib)