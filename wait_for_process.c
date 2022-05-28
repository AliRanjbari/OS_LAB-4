#include "types.h"
#include "stat.h"
#include "user.h"
#include "syscall.h"

int main()
{

    
    int child1 = fork();
    if(child1 != 0) {
        printf(1, "process %d created\n", child1);
        int child2 = fork();
        if(child2 != 0) {
            printf(1, "process %d created\n", child2);
            write(1, "parent\n", 7);
        }
        else {
            wait_for_process(child1);
            write(1, "finish: child2\n",15);
        }

    }
    else {
        sleep(100);
        write(1, "finish: child1\n", 15);
    }

    while(wait() != -1);
    exit();
}



