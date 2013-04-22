#include <sstream>
#include <iomanip>
#include <apr.h>
#include <apr_sha1.h>
#include <apr_file_io.h>

int sha1_file(const std::string& filename, std::string& checksum, bool binary)
{
  apr_initialize();
  apr_pool_t* pool;
  apr_pool_create(&pool, NULL);
  
  apr_file_t* in;
  apr_int32_t flags = (binary ? APR_READ | APR_BINARY : APR_READ);
  apr_file_open(&in, filename.c_str(), flags, APR_OS_DEFAULT, pool);
  
  char buffer[512];
  memset(buffer, 0, sizeof(buffer));
  apr_size_t bytes_read = 0;
  apr_file_read_full(in, buffer, 512, &bytes_read);
  apr_file_close(in);
  
  unsigned char digest[APR_SHA1_DIGESTSIZE + 1];
  memset(digest, 0, APR_SHA1_DIGESTSIZE + 1);
  
  apr_sha1_ctx_t context;
  apr_sha1_init(&context);
  if(binary) apr_sha1_update_binary(&context, (const unsigned char*)buffer, bytes_read);
  else apr_sha1_update(&context, buffer, bytes_read);
  apr_sha1_final(digest, &context);
  
  std::ostringstream oss;
  for(int i = 0; i < APR_SHA1_DIGESTSIZE; i++)
  {
    unsigned short letter = digest[i];
    oss << std::hex << std::setw(2) << std::setfill('0') << letter;
  }
  
  checksum = oss.str();
  
  apr_pool_destroy(pool);
  apr_terminate();
  
  return 0;
}
