#include <stdio.h>

int main()
{
    char t2[16];
    char t1[16];
    char s[] = "test-data0123456789";

    t2[0] = 'S';
    t2[1] = '\0';

    int i = 0;
    do
    {
        t1[i] = s[i];
    } while (s[i++] != '\0');

    puts(t1);
    puts(t2);

    int *ptr = (int *)t1;
    printf("%d\n", *ptr);

    return 0;
}
