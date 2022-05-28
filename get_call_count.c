// #include <stdio.h>
#include "types.h"
#include "stat.h"
#include "user.h"
#include "syscall.h"

int main()
{

    
    int child1 = fork();
    if(child1 != 0) {
        wait();
        int child2 = fork();
        if(child2 != 0) {
            wait();
            write(1, "parent\n", 7);
            printf(1, "parent write count: %d\n", get_call_count(SYS_write));
            printf(1, "parent fork count: %d\n", get_call_count(SYS_fork));

        }
        else {
            write(1, "child2\n", 7);
            printf(1, "child2 write count: %d\n", get_call_count(SYS_write));
            printf(1, "child2 fork count: %d\n", get_call_count(SYS_fork));
        }

    }
    else {
        write(1, "child1\n", 7);
        printf(1, "child1 write count: %d\n", get_call_count(SYS_write));
        printf(1, "child1 fork count: %d\n", get_call_count(SYS_fork));
    }

    exit();
}

