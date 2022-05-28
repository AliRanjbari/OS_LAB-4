#include "types.h"
#include "user.h"
#include "stat.h"

int main(int argc, char * argv[]) {
    char buff[1024];
    int a, tempEBX;
    if(argc < 2) {
        printf(1, "enter an integer:\n");
        read(0, buff, 1024);
        a = atoi(buff);
    } else {
        a = atoi(argv[1]);
    }
    asm volatile(
		"movl %%ebx, %0;" // saved_ebx = ebx
		"movl %1, %%ebx;" // ebx = number
		: "=r" (tempEBX)
		: "r"(a)
	);
	printf(1, "in user mode find_next_prime_num() called\n");
	printf(1, "sum of digits is %d\n" , find_next_prime_num(a));
	asm("movl %0, %%ebx" : : "r"(tempEBX)); // ebx = saved_ebx -> restore
	exit();
}