#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"



void
sort_string(char* string, int fd){
    int length = strlen(string);

    for(int i=0; i<length; i++)
        for(int j=i; j<length; j++)
            if(string[i] > string[j]){
                char temp = string[i];
                string[i] = string[j];
                string[j] = temp;
            }

    write(fd, string, strlen(string));
    write(fd, "\n", 1);
}


int 
main(int argc, char *argv[]){
    if(argc < 2){
        printf(1, "please enter a string\n");
    }
    else{
        close(1);                   //close fd 1
        int fd = open("sort_string.txt", O_CREATE|O_WRONLY);      
        sort_string(argv[1], fd);
        close(fd);
    }
    exit();
}