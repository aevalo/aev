#include <apr.h>
#include <apr_file_io.h>
#include <iostream>
#include <sstream>
#include <string>

template <class CharT, class TraitsT = std::char_traits<CharT> >
class basic_debugbuf : public std::basic_stringbuf<CharT, TraitsT>
{
  public:
    basic_debugbuf() : _pool(NULL) { apr_pool_create(&_pool, NULL); }
    virtual ~basic_debugbuf() { sync(); apr_pool_destroy(_pool); }
  
  protected:
    int sync()
    {
      std::basic_string<CharT, TraitsT> s = str();
      std::cout << (char*)s.c_str() << std::endl;
      output_debug_string(this->str().c_str());
      this->str(std::basic_string<CharT>());    // Clear the string buffer
      return 0;
    }
    
    void output_debug_string(const CharT *text) {}
  
  private:
    apr_pool_t* _pool;
};

template<>
void basic_debugbuf<char>::output_debug_string(const char *text)
{
  apr_file_t* out = NULL;
  apr_file_open_stdout(&out, _pool);
  apr_file_printf(out, "%s\n", text);
  apr_file_close(out);
}

template<>
void basic_debugbuf<wchar_t>::output_debug_string(const wchar_t *text)
{
}

template<class CharT, class TraitsT = std::char_traits<CharT> >
class basic_dostream : public std::basic_ostream<CharT, TraitsT>
{
  public:
    basic_dostream()
      : std::basic_ostream<CharT, TraitsT>(new basic_debugbuf<CharT>()) {}
    ~basic_dostream() { delete this->rdbuf(); }
};

typedef basic_dostream<char>    dostream;
typedef basic_dostream<wchar_t> wdostream;

int main(int argc, const char* const argv[])
{
  apr_app_initialize(&argc, &argv, NULL);
  dostream() << "Hello, World!!!";
  apr_terminate();
  return 0;
}
  