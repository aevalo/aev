#include <cstdio>
#include "dynlib.hpp"

typedef const char* (*version_func_t)();

int main(int argc, char* argv[])
{
  dynlib zlib("libz.so");
  version_func_t zlibVersion = reinterpret_cast<version_func_t>(zlib::sym("zlibVersion", h));
  if (zlibVersion)
  {
    fprintf(stdout, "zlib version: %s\n", (zlibVersion)());
  }
  zlib::close();
  return 0;
}
