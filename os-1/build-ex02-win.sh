#!/bin/sh

nasm -f bin boot1.asm

gcc -S -static boot2.c

echo '.org 0x8200' > foo.s
cat boot2.s >> foo.s
mv foo.s boot2.s

as -R -o boot2.o boot2.s

objcopy -O binary boot2.o foo
dd if=foo of=boot2 skip=65
rm foo

dd if=/dev/zero of=fdd.img count=2880
cat boot1 boot2 > boot
dd if=boot of=fdd.img conv=notrunc
