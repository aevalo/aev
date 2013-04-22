#ifndef DYNLIB_HPP_INCLUDED
#define DYNLIB_HPP_INCLUDED

#ifdef WIN32
typedef HANDLE dynlib_handle_t;
#else
typedef void* dynlib_handle_t;
#endif

class dynlib
{
  public:
    dynlib();
    dynlib(const char* path);
    ~dynlib();
    
     bool open(const char* path);
     void* sym(const char* name);
     bool close();
  
  private:
    dynlib(const dynlib& dl);
    dynlib& operator=(const dynlib& rhs);
    
    dynlib_handle_t _handle;
};

#endif // DYNLIB_HPP_INCLUDED
