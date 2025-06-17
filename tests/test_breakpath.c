#include <stdio.h>
#include <string.h>

char *breakpath(char *);

int main(void)
{
    char path[] = "/foo/bar";
    char *base = breakpath(path);

    if (strcmp(base, "bar") != 0) {
        fprintf(stderr, "base name wrong: %s\n", base);
        return 1;
    }
    if (strcmp(path, "/foo") != 0) {
        fprintf(stderr, "dir name wrong: %s\n", path);
        return 1;
    }
    return 0;
}
