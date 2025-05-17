#include <unistd.h>       // for STDIN_FILENO and read
#include <termios.h>      // for terminal I/O control (tcgetattr, tcsetattr)
#include <fcntl.h>        // for file descriptor flags (fcntl)
#include <stdio.h>        // for getchar, ungetc, stdin
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>


void init_rng() { 
    struct timeval tv;
    gettimeofday(&tv, NULL);
    // Combine seconds and microseconds to get a more varied seed
    int seed =  (int)(tv.tv_sec ^ tv.tv_usec);
    srand(seed); 
}

int random_range(int* low, int* high) {
    init_rng();

    int min = *low; 
    int max = *high;
    return min + rand() % (max - min + 1);
}

int random_range2(int *low) {
    int min = *low; 
    int max = 2 * min;
    return random_range(low, &max);
}

int getchar_nonblock(){
    struct termios new_attr, old_attr;
    int oldf;
    int ch;

    tcgetattr(STDIN_FILENO, &old_attr); // Gets the current terminal attributes
    new_attr = old_attr;                // Keep the old attributes safe
    new_attr.c_lflag &= ~(ICANON | ECHO); // disable line buffered input and show chars to the screen
    tcsetattr(STDIN_FILENO, TCSANOW, &new_attr); // set the updated attrs

    oldf = fcntl(STDIN_FILENO, F_GETFL, 0);     // Save and modify file descriptor flags
    fcntl(STDIN_FILENO, F_SETFL, oldf | O_NONBLOCK);

    ch = getchar();

    tcsetattr(STDIN_FILENO, TCSANOW, &old_attr);
    fcntl(STDIN_FILENO, F_SETFL, oldf);
    return ch;

}

/*
int main(){
    int i = 0;
    int ch;
    for( i=0; i< 1000; i++){
        printf("%d\n", i);
        ch = getchar_nonblock();
        if (ch != -1){
            printf("The char is: %d\n", ch);
        }        
        usleep(100000);
    }
    
    return 0;
}
    */