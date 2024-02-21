#!/bin/sh

nasm -f bin boot1b.asm

gcc -S -static keyboard.c

echo '.org 0x8200' > foo.s
cat keyboard.s >> foo.s
mv foo.s keyboard.s

as -R -o keyboard.o keyboard.s

objcopy -O binary keyboard.o foo
dd if=foo of=keyboard skip=65
rm foo

dd if=/dev/zero of=fdd.img count=2880
cat boot1b keyboard > boot
dd if=boot of=fdd.img conv=notrunc
