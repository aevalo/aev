#include <iostream>
#include <sstream>
#include <fstream>
#include <iomanip>
#include <apr.h>
#include <apr_sha1.h>
#include <apr_file_io.h>

int main(int argc, char* argv[])
{
  if (argc < 2 )
  {
    std::cerr << "File name must be given." << std::endl;
    return 1;
  }
  
  apr_initialize();
  apr_pool_t* pool;
  apr_pool_create(&pool, NULL);
  
  apr_file_t* in;
  apr_file_open(&in, argv[1], APR_READ | APR_BINARY, APR_OS_DEFAULT, pool);
  
  unsigned char buffer[512];
  memset(buffer, 0, sizeof(buffer));
  apr_size_t bytes_read = 0;
  apr_file_read_full(in, buffer, 512, &bytes_read);
  apr_file_close(in);
  
  unsigned char digest[APR_SHA1_DIGESTSIZE + 1];
  memset(digest, 0, APR_SHA1_DIGESTSIZE + 1);
  
  std::cout << buffer;
  apr_sha1_ctx_t context;
  apr_sha1_init(&context);
  apr_sha1_update_binary(&context, buffer, bytes_read);
  apr_sha1_final(digest, &context);
  
  for(int i = 0; i < APR_SHA1_DIGESTSIZE; i++)
  {
    unsigned short letter = digest[i];
    std::cout << std::hex << std::setw(2) << std::setfill('0') << letter;
  }
  
  std::cout << "  " << argv[1] << std::endl;
  
  apr_pool_destroy(pool);
  apr_terminate();
  return 0;
}

