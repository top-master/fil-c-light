#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdfil.h>
#include <string.h>
#include <sys/wait.h>
#include <errno.h>

static void writeloop(int fd, char* data, size_t size)
{
    while (size) {
        ssize_t result = write(fd, data, size);
        zprintf("Wrote %ld bytes.\n", result);
        ZASSERT(result);
        if (result == -1) {
            ZASSERT(errno == EINTR);
            continue;
        }
        ZASSERT(result > 0);
        ZASSERT(result <= size);
        data += result;
        size -= result;
    }
}

static size_t readloop(int fd, char* data, size_t size)
{
    size_t bytes_read = 0;
    while (size) {
        ssize_t result = read(fd, data, size);
        zprintf("Read %ld bytes.\n", result);
        if (!result)
            return bytes_read;
        if (result == -1) {
            ZASSERT(errno == EINTR);
            continue;
        }
        ZASSERT(result > 0);
        ZASSERT(result <= size);
        data += result;
        size -= result;
        bytes_read += result;
    }
    return bytes_read;
}

static void child(int sockfd)
{
    int socks1[2];
    ZASSERT(!socketpair(AF_UNIX, SOCK_STREAM, 0, socks1));
    int socks2[2];
    ZASSERT(!socketpair(AF_UNIX, SOCK_STREAM, 0, socks2));

    struct msghdr msg1;
    union {
        struct cmsghdr hdr;
        char buf[CMSG_SPACE(sizeof(int))];
    } cmsgbuf1;
    struct cmsghdr* cmsg1;
    struct msghdr msg2;
    union {
        struct cmsghdr hdr;
        char buf[CMSG_SPACE(sizeof(int))];
    } cmsgbuf2;
    struct cmsghdr* cmsg2;

    memset(&msg1, 0, sizeof(msg1));
    memset(&cmsgbuf1, 0, sizeof(cmsgbuf1));
    msg1.msg_control = cmsgbuf1.buf;
    msg1.msg_controllen = sizeof(cmsgbuf1.buf);
    cmsg1 = CMSG_FIRSTHDR(&msg1);
    cmsg1->cmsg_len = CMSG_LEN(sizeof(int));
    zprintf("cmsg1->cmsg_len = %u\n", (unsigned)cmsg1->cmsg_len);
    cmsg1->cmsg_level = SOL_SOCKET;
    cmsg1->cmsg_type = SCM_RIGHTS;
    *(int*)CMSG_DATA(cmsg1) = socks1[0];

    char thingy1 = (char)42;
    
    struct iovec vec1;
    vec1.iov_base = &thingy1;
    vec1.iov_len = 1;
    msg1.msg_iov = &vec1;
    msg1.msg_iovlen = 1;

    memset(&msg2, 0, sizeof(msg2));
    memset(&cmsgbuf2, 0, sizeof(cmsgbuf2));
    msg2.msg_control = cmsgbuf2.buf;
    msg2.msg_controllen = sizeof(cmsgbuf2.buf);
    cmsg2 = CMSG_FIRSTHDR(&msg2);
    cmsg2->cmsg_len = CMSG_LEN(sizeof(int));
    zprintf("cmsg2->cmsg_len = %u\n", (unsigned)cmsg2->cmsg_len);
    cmsg2->cmsg_level = SOL_SOCKET;
    cmsg2->cmsg_type = SCM_RIGHTS;
    *(int*)CMSG_DATA(cmsg2) = socks2[0];

    char thingy2 = (char)43;
    
    struct iovec vec2;
    vec2.iov_base = &thingy2;
    vec2.iov_len = 1;
    msg2.msg_iov = &vec2;
    msg2.msg_iovlen = 1;

    zprintf("About to sendmsg (1). Sending fd = %d using fd = %d\n", socks1[0], sockfd);

    for (;;) {
        ssize_t send_result = sendmsg(sockfd, &msg1, 0);
        int my_errno = errno;
        if (send_result == 1)
            break;
        ZASSERT(send_result == -1);
        ZASSERT(my_errno == EINTR);
    }

    zprintf("About to sendmsg (2). Sending fd = %d using fd = %d\n", socks2[0], sockfd);

    for (;;) {
        ssize_t send_result = sendmsg(sockfd, &msg2, 0);
        int my_errno = errno;
        if (send_result == 1)
            break;
        ZASSERT(send_result == -1);
        ZASSERT(my_errno == EINTR);
    }

    /* Gotta acknowledge that the other side got the file descriptors. If they get it after we exit,
       then they'll get a file descriptor that doesn't work. (Reproduced by running this test in
       legacy C on Darwin.) */
    char dummy;
    ZASSERT(readloop(sockfd, &dummy, 1) == 1);

    writeloop(socks1[1], "hello", strlen("hello") + 1);
    writeloop(socks2[1], "world", strlen("world") + 1);
}

static void parent(int sockfd)
{
    struct msghdr msg1;
    union {
        struct cmsghdr hdr;
        char buf[CMSG_SPACE(sizeof(int))];
    } cmsgbuf1;
    struct cmsghdr* cmsg1;
    struct iovec vec1;
    char thingy1;

    memset(&msg1, 0, sizeof(msg1));
    vec1.iov_base = &thingy1;
    vec1.iov_len = 1;
    msg1.msg_iov = &vec1;
    msg1.msg_iovlen = 1;
    memset(&cmsgbuf1, 0, sizeof(cmsgbuf1));
    msg1.msg_control = &cmsgbuf1.buf;
    msg1.msg_controllen = sizeof(cmsgbuf1.buf);

    struct msghdr msg2;
    union {
        struct cmsghdr hdr;
        char buf[CMSG_SPACE(sizeof(int))];
    } cmsgbuf2;
    struct cmsghdr* cmsg2;
    struct iovec vec2;
    char thingy2;

    memset(&msg2, 0, sizeof(msg2));
    vec2.iov_base = &thingy2;
    vec2.iov_len = 1;
    msg2.msg_iov = &vec2;
    msg2.msg_iovlen = 1;
    memset(&cmsgbuf2, 0, sizeof(cmsgbuf2));
    msg2.msg_control = &cmsgbuf2.buf;
    msg2.msg_controllen = sizeof(cmsgbuf2.buf);

    for (;;) {
        ssize_t recv_result = recvmsg(sockfd, &msg1, 0);
        int my_errno = errno;
        if (recv_result == 1)
            break;
        zprintf("recv_result = %ld, error = %s\n", (long)recv_result, strerror(my_errno));
        ZASSERT(recv_result == -1);
        ZASSERT(my_errno == EINTR);
    }

    ZASSERT(thingy1 == (char)42);

    for (;;) {
        ssize_t recv_result = recvmsg(sockfd, &msg2, 0);
        int my_errno = errno;
        if (recv_result == 1)
            break;
        zprintf("recv_result = %ld, error = %s\n", (long)recv_result, strerror(my_errno));
        ZASSERT(recv_result == -1);
        ZASSERT(my_errno == EINTR);
    }

    ZASSERT(thingy2 == (char)43);

    cmsg1 = CMSG_FIRSTHDR(&msg1);
    ZASSERT(cmsg1);
    ZASSERT(cmsg1->cmsg_type == SCM_RIGHTS);
    ZASSERT(cmsg1->cmsg_level == SOL_SOCKET);
    ZASSERT(cmsg1->cmsg_len = CMSG_LEN(sizeof(int)));
    int othersockfd1 = *(int*)CMSG_DATA(cmsg1);
    zprintf("othersockfd1 = %d\n", othersockfd1);

    cmsg2 = CMSG_FIRSTHDR(&msg2);
    ZASSERT(cmsg2);
    ZASSERT(cmsg2->cmsg_type == SCM_RIGHTS);
    ZASSERT(cmsg2->cmsg_level == SOL_SOCKET);
    ZASSERT(cmsg2->cmsg_len = CMSG_LEN(sizeof(int)));
    int othersockfd2 = *(int*)CMSG_DATA(cmsg2);
    zprintf("othersockfd1 = %d\n", othersockfd2);

    char dummy;
    writeloop(sockfd, &dummy, 1);

    char buf[100];
    ZASSERT(readloop(othersockfd1, buf, sizeof(buf)) == strlen("hello") + 1);
    ZASSERT(!strcmp(buf, "hello"));
    ZASSERT(readloop(othersockfd2, buf, sizeof(buf)) == strlen("world") + 1);
    ZASSERT(!strcmp(buf, "world"));
}

int main()
{
    int socks[2];
    ZASSERT(!socketpair(AF_UNIX, SOCK_STREAM, 0, socks));

    int result = fork();
    ZASSERT(result >= 0);
    if (!result) {
        zprintf("Running child!\n");
        close(socks[1]);
        child(socks[0]);
        zprintf("Child OK\n");
    } else {
        zprintf("Running parent!\n");
        close(socks[0]);
        parent(socks[1]);
        wait(NULL);
        zprintf("Parent OK\n");
    }
    return 0;
}

