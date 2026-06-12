/*
 * healthcheck.c — minimal HTTP health check för nginx (Alpine/musl)
 *
 * Usage: healthcheck [address [port [path]]]
 *   Default: healthcheck 127.0.0.1 80 /health
 *
 * Exits 0 if nginx responds with HTTP 2xx or 3xx, 1 otherwise.
 * Compile: gcc -static -O2 -o healthcheck healthcheck.c
 *
 * Note: address måste vara en IPv4-adress i punktnotation (ej hostname).
 */

#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

#define DEFAULT_HOST  "127.0.0.1"
#define DEFAULT_PORT   8080
#define DEFAULT_PATH   "/health"
#define TIMEOUT_SEC    5
#define BUFSIZE        512

int main(int argc, char *argv[])
{
    const char *host = DEFAULT_HOST;
    int         port = DEFAULT_PORT;
    const char *path = DEFAULT_PATH;

    if (argc > 1) host = argv[1];
    if (argc > 2) port = atoi(argv[2]);
    if (argc > 3) path = argv[3];

    int fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0) return 1;

    /* Timeout gäller send/recv — connect mot localhost är i praktiken omedelbart */
    struct timeval tv;
    tv.tv_sec  = TIMEOUT_SEC;
    tv.tv_usec = 0;
    setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv));
    setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &tv, sizeof(tv));

    struct sockaddr_in addr = {
        .sin_family      = AF_INET,
        .sin_port        = htons((uint16_t)port),
        .sin_addr.s_addr = inet_addr(host),
    };

    if (connect(fd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        close(fd);
        return 1;
    }

    char req[256];
    int  reqlen = snprintf(req, sizeof(req),
        "GET %s HTTP/1.0\r\n"
        "Host: %s\r\n"
        "Connection: close\r\n"
        "\r\n",
        path, host);

    if (send(fd, req, (size_t)reqlen, 0) != (ssize_t)reqlen) {
        close(fd);
        return 1;
    }

    char    buf[BUFSIZE];
    ssize_t n = recv(fd, buf, sizeof(buf) - 1, 0);
    close(fd);

    /* Minsta möjliga svar: "HTTP/1.0 200 OK\r\n..." = 17 tecken */
    if (n < 12) return 1;
    buf[n] = '\0';

    /* Parsa statuskoden från "HTTP/1.x NNN ..." */
    char *sp = strchr(buf, ' ');
    if (!sp) return 1;

    int status = atoi(sp + 1);
    return (status >= 200 && status < 400) ? 0 : 1;
}
