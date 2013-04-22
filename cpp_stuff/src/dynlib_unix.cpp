#include <dlfcn.h>
#include <cstdio>
#include "dynlib.hpp"

dynlib::dynlib()
  : _handle(NULL)
{
}

dynlib::dynlib(const char* path)
  : _handle(NULL)
{
  open(path);
}

dynlib::~dynlib()
{
  if (_handle)
  {
    close();
  }
}

bool dynlib::open(const char* path)
{
  _handle = dlopen(path, RTLD_LOCAL | RTLD_LAZY);
  if (_handle == NULL)
  {
    fprintf(stderr, "Error occurred while opening dynamic library: %s\n", *dlerror());
    return false;
  }
  return true;
}

void* dynlib::sym(const char* name)
{
  void* sym_ptr = dlsym(_handle, name);
  if (sym_ptr == NULL)
  {
    fprintf(stderr, "Error occurred while loading symbol from dynamic library: %s\n", *dlerror());
  }
  return sym_ptr;
}

bool dynlib::close()
{
  int ret = dlclose(_handle);
  if (ret != 0)
  {
    fprintf(stderr, "Error occurred while closing dynamic library: %s\n", *dlerror());
    return false;
  }
  _handle = NULL;
  return true;
}
