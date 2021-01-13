#include <stdio.h>
#include "ex1.h"

//Checks whether the current system works in big or little endian
int is_big_endian()
{
    unsigned long num = 1;
    char *mem = (char *)&num;
    if (*mem)
    {
        return 0;
    }
    return 1;
}

//concatenate the first half of bytes from x with the second half of bytes from y
unsigned long merge_bytes(unsigned long x, unsigned long y)
{
    int i=0;
    unsigned long new_num;
    char *first_ptr;
    char *last_ptr;
    char *new_num_ptr = (char *)&new_num;

    // choose the correct order for x and y
    if (is_big_endian() == 1)
    {
        first_ptr = (char *)&x;
        last_ptr = (char *)&y;
    }
    else
    {
        first_ptr = (char *)&y;
        last_ptr = (char *)&x;
    }

    // concatenate the required bytes
    for (i = 0; i < sizeof(new_num) / 2; i++)
    {
        new_num_ptr[i] = first_ptr[i];
    }
    for (i = sizeof(new_num) / 2; i < sizeof(new_num); i++)
    {
        new_num_ptr[i] = last_ptr[i];
    }
    return new_num;
}

//Puts the byte b in position w/8-i-1 of the input number x
unsigned long put_byte(unsigned long x, unsigned char b, int i)
{
    char *x_ptr = (char *)&x;
    if (is_big_endian() == 1)
    {
        x_ptr[i] = b;
    }
    else
    {
        x_ptr[sizeof(x) - 1 - i] = b;
    }
    return x;
}
