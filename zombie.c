#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

int main()
{
    for (int i = 0; i < 10; i++)
    {
        if (fork() == 0)
        {
            // Child exits immediately
            exit(0);
        }
    }

    // Parent just sleeps, doesn't wait on children
    sleep(30);
    return 0;
}
