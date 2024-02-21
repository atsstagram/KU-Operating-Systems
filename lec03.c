#include <stdio.h>

// 普通だと値が保存されていない。staticをつけるor関数外で宣言すると大域変数領域に

// int a;    //保存される

int func(int initialize)
{
    //  int a;  //保存されない
    // static int a;    //保存される

    if (initialize) // c、0以外true
        a = 0;
    else
        a++;

    return a;
}

int main(int argc, char **arcv)
{
    int i;

    func(1);
    for (i = 0; i < 5; i++)
    {
        printf("%d\n", func(0));
    }
}