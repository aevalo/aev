#VARIABLES: The registers have the following uses:
# description: this function takes an int array and multiplies
#              every element by 2 and adds 5.
# %edi - Holds the index of the data item being examined
# %ecx - size of the array
# %eax - pointer to first item in array
# %edx - used for scratch space
#
.section .text
.globl asm_mod_array
.type asm_mod_array, @function
asm_mod_array:
pushl %ebp
movl %esp, %ebp
movl 8(%ebp),%eax          # get pointer to start of array passed from C
movl 12(%ebp),%ecx         # get size of array
xorl %edi, %edi            # zero out our array index

start_loop:                # start loop
cmpl %edi, %ecx            # check to see if we’ve hit the end
je loop_exit
movl (%eax,%edi,4), %edx   # store the element in %edx for calculations
leal 5(,%edx,2), %edx      # multiply array element by 2 and add 5
movl %edx, (%eax,%edi,4)   # overwrite old element with new value
incl %edi                  # increment the index, moving through the array.
jmp start_loop             # jump to loop beginning

loop_exit:                 # function epilogue
movl %ebp, %esp
popl %ebp
ret                        # pop the return address and jmp to it
