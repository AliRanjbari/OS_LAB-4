// #include <stdio.h>
#include "types.h"
#include "stat.h"
#include "user.h"
#include "syscall.h"

int main()
{
    printf(1, "process id: %d\n", getpid());

    for(int i=0; i<1000; i++)
        write(1, "i", 1 );


    write(1, "\n", 1);
    

    printf(1, "most write caller: %d\n", get_most_caller(SYS_write));
    printf(1, "most wait caller: %d\n", get_most_caller(SYS_wait));
    printf(1, "most fork caller: %d\n", get_most_caller(SYS_fork));

    exit();
}

