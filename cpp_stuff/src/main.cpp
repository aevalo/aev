#include <cstdio>
#include "dynlib.hpp"

typedef const char* (*version_func_t)();

class compressor
{
  public:
    virtual ~compressor() {_dl.close();}

    virtual bool get_syms() = 0;
    virtual const char* version() = 0;

  protected:

    compressor(const char* path) {_dl.open(path);}
    compressor(const compressor& c);
    compressor& operator=(const compressor& rhs);


    dynlib _dl;
};

class zlib_compressor : public compressor
{
  public:
    zlib_compressor() : compressor("libz.so"), version_func(NULL) {}
    virtual ~zlib_compressor() {}

    virtual bool get_syms() {version_func = reinterpret_cast<version_func_t>(_dl.sym("zlibVersion"));}
    virtual const char* version() {if(version_func){return (version_func)();}return "";}

  protected:


  private:

    version_func_t version_func;
};

int main(int argc, char* argv[])
{
  zlib_compressor zlib;
  zlib.get_syms();
  fprintf(stdout, "zlib version: %s\n", zlib.version());
  return 0;
}
