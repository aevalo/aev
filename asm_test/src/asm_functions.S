#include "asm_const.h"

.section .text

.globl asm_foo

.type asm_foo, @function
asm_foo:
  pushl %ebp
  movl %esp, %ebp
  xorl %eax, %eax
  
  movl 8(%ebp), %ecx
  
  cmpl $ASM_CMD_ADD, %ecx
  je do_add
  
  cmpl $ASM_CMD_SUB, %ecx
  je do_sub
  
  jmp do_exit
  
do_add:
  addl 12(%ebp), %eax
  addl 16(%ebp), %eax
  jmp do_exit
  
do_sub:
  subl 12(%ebp), %eax
  subl 16(%ebp), %eax
  jmp do_exit
  
do_exit:
  movl %ebp, %esp
  popl %ebp
  ret
