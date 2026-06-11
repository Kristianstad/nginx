#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <stdlib.h>
#include <signal.h>

int main(int argc, char **argv) {
    int port = 8080;

    signal(SIGALRM, SIG_DFL);
    alarm(3);

    int s = socket(AF_INET, SOCK_STREAM, 0);
    if (s < 0) return 1;

    struct sockaddr_in a = {0};
    a.sin_family      = AF_INET;
    a.sin_port        = htons((unsigned short)port);
    a.sin_addr.s_addr = htonl(INADDR_LOOPBACK);

    int r = connect(s, (struct sockaddr *)&a, sizeof(a));
    close(s);
    return r == 0 ? 0 : 1;
}
