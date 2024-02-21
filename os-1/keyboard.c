// boot2.c の代わり

#define KBD_STATUS 0x64
#define KBD_DATA 0x60
#define KEY_UP_BIT 0x80
#define SCREEN_WIDTH 320

static void kbd_handler(void);
static void register_kbd_handler(void);
static int print(int num, int x, int y, int color);
static int in8(int port);
static int out8(int port, int value);
static int sti(void);
static int cli(void);
static int halt(void);
static int sti_and_halt(void);

// 関数 boot2() より前に他の関数の定義(実装)や、大域変数宣言を書いてはいけない

/*
//元のプログラム
void boot2(void) {
  while ((in8(KBD_STATUS) & 1) == 0)
    ;

  int value = in8(KBD_DATA);
  if (value & KEY_UP_BIT)    // if key up
    print(1, 100, 50, 15);
  else
    print(0, 100, 50, 15);

  int key = value & 0x7f;
  halt();
}
*/

// 変更した boot2
void boot2(void)
{

  for (int i = 0; i < 100; i++)
  {
    while ((in8(KBD_STATUS) & 1) == 0)
      ;

    int value = in8(KBD_DATA);

    /*
    if (value & KEY_UP_BIT)    // if key up
      print(1, 100, 50, 15);
    else
      print(0, 100, 50, 15);
    */

    int key = value & 0x7f; // 押されたキーの番号
    key--;                  // なぜかこれが必要←？？？？？？？

    if (0 <= key && key <= 9)
      print(key, 100 + 5 * key, 50, 15);

    /*
    if (key == 0)
      print(0, 100, 50, 15);
    else if (key == 1)
      print(1, 105, 50, 15);
    else if (key == 2)
      print(2, 110, 50, 15);
    else if (key == 3)
      print(3, 115, 50, 15);
    else if (key == 4)
      print(4, 120, 50, 15);
    else if (key == 5)
      print(5, 125, 50, 15);
    else if (key == 6)
      print(6, 130, 50, 15);
    else if (key == 7)
      print(7, 135, 50, 15);
    else if (key == 8)
      print(8, 140, 50, 15);
    else if (key == 9)
      print(9, 145, 50, 15);
    // else
    // continue;
    */
  }

  halt();
}

static int xpos = 100;

static void kbd_handler(void)
{
  out8(0x20, 0x61); // PIC0_OCW2: accept IRQ1 again
  int value = in8(KBD_DATA);

  // 表示: ここを書き換えればよい
  print(0, xpos, 60, 14);
  xpos += 5;
}

// 割り込み処理関数を登録する
static void register_kbd_handler(void)
{
  int *ptr = (int *)0x7e00;
  *ptr = (int)kbd_handler;
  sti();
  out8(0x21, 0xf9); // PIC0_IMR: accept only IRQ1 and IRQ2 (PIC1)
  out8(0xa1, 0xff); // PIC1_IMR: no interrupt
}

static int print(int num, int x, int y, int color)
{
  static char bitmaps[][4] = {
      {0x7e, 0x81, 0x81, 0x7e}, // 0
      {0x00, 0x41, 0xff, 0x01}, // 1

      // 変更ここから
      {0x43, 0x85, 0x89, 0x73}, // 2
      {0x42, 0x91, 0x91, 0x6e}, // 3
      {0xf8, 0x08, 0xff, 0x08}, // 4
      {0xf2, 0x91, 0x91, 0x8e}, // 5
      {0x3e, 0x49, 0x91, 0x8e}, // 6
      {0x80, 0x8f, 0xb0, 0xc0}, // 7
      {0x6e, 0x91, 0x91, 0x6e}, // 8
      {0x71, 0x89, 0x92, 0x7c}  // 9

      // 変更ここまで
  };

  int i, j;
  char *vram = (char *)0xa0000;
  char *map = bitmaps[num];
  vram += (y * SCREEN_WIDTH + x);

  for (i = 0; i < 8; i++)
  {
    for (j = 0; j < 4; j++)
    {
      char bits = map[j];
      if (bits & (0x80 >> i))
        *(vram + j) = color;
    }

    vram += SCREEN_WIDTH;
  }

  return 0;
}

// in 命令で port の値 (8bit) を読む
static int in8(int port)
{
  int value;
  asm volatile("mov $0, %%eax\n\tin %%dx,%%al"
               : "=a"(value)
               : "d"(port));
  return value;
}

// out 命令で port に値 (8bit) を書き込む
static int out8(int port, int value)
{
  asm volatile("out %%al,%%dx"
               :
               : "d"(port), "a"(value));
  return 0;
}

// sti 命令 (割り込み許可) を実行
static int sti(void)
{
  asm volatile("sti");
  return 0;
}

// cli 命令 (割り込み禁止) を実行
static int cli(void)
{
  asm volatile("cli");
  return 0;
}

// hlt 命令でプロセッサを停止させる
static int halt(void)
{
  asm volatile("hlt");
  return 0;
}

// sti 命令と hlt 命令を連続して実行
// sti してから hlt までのわずかの時間に割り込みが発生しないようにする。
static int sti_and_halt(void)
{
  asm volatile("sti\n\thlt");
  return 0;
}
