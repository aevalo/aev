#include <stdio.h>
#include "asm_functions.h"

int main(int argc, char* argv[])
{
  printf("asm_foo(ASM_CMD_ADD, 2, 3) => %d\n\n", asm_foo(ASM_CMD_ADD, 2, 3));
  printf("asm_foo(ASM_CMD_SUB, 2, 3) => %d\n\n", asm_foo(ASM_CMD_SUB, 2, 3));
  printf("asm_foo(1, 2, 3) => %d\n\n", asm_foo(1, 2, 3));

  int i = 0;
  int fren[5]={ 1, 2, 3, 4, 5 };
  
  printf("Before:\n");
  for(; i < 5; i++)
    printf("%d) %d\n", i + 1, fren[i]);
    
  /* call the asm function */
  asm_mod_array(fren, 5);
  
  printf("\nAfter:\n");
  for(i = 0; i < 5; i++)
    printf("%d) %d\n", i + 1, fren[i]);
    
  return 0;
}
