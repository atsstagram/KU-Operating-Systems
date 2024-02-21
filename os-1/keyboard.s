.org 0x8200
	.file	"keyboard.c"
	.text
	.globl	boot2
	.type	boot2, @function
boot2:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$0, -12(%ebp)
	jmp	.L2
.L5:
	nop
.L3:
	subl	$12, %esp
	pushl	$100
	call	in8
	addl	$16, %esp
	andl	$1, %eax
	testl	%eax, %eax
	je	.L3
	subl	$12, %esp
	pushl	$96
	call	in8
	addl	$16, %esp
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	andl	$127, %eax
	movl	%eax, -20(%ebp)
	subl	$1, -20(%ebp)
	cmpl	$0, -20(%ebp)
	js	.L4
	cmpl	$9, -20(%ebp)
	jg	.L4
	movl	-20(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	addl	$100, %eax
	pushl	$15
	pushl	$50
	pushl	%eax
	pushl	-20(%ebp)
	call	print
	addl	$16, %esp
.L4:
	addl	$1, -12(%ebp)
.L2:
	cmpl	$99, -12(%ebp)
	jle	.L5
	call	halt
	nop
	leave
	ret
	.size	boot2, .-boot2
	.data
	.align 4
	.type	xpos, @object
	.size	xpos, 4
xpos:
	.long	100
	.text
	.type	kbd_handler, @function
kbd_handler:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	subl	$8, %esp
	pushl	$97
	pushl	$32
	call	out8
	addl	$16, %esp
	subl	$12, %esp
	pushl	$96
	call	in8
	addl	$16, %esp
	movl	%eax, -12(%ebp)
	movl	xpos, %eax
	pushl	$14
	pushl	$60
	pushl	%eax
	pushl	$0
	call	print
	addl	$16, %esp
	movl	xpos, %eax
	addl	$5, %eax
	movl	%eax, xpos
	nop
	leave
	ret
	.size	kbd_handler, .-kbd_handler
	.type	register_kbd_handler, @function
register_kbd_handler:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$32256, -12(%ebp)
	movl	$kbd_handler, %edx
	movl	-12(%ebp), %eax
	movl	%edx, (%eax)
	call	sti
	subl	$8, %esp
	pushl	$249
	pushl	$33
	call	out8
	addl	$16, %esp
	subl	$8, %esp
	pushl	$255
	pushl	$161
	call	out8
	addl	$16, %esp
	nop
	leave
	ret
	.size	register_kbd_handler, .-register_kbd_handler
	.type	print, @function
print:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$32, %esp
	movl	$655360, -16(%ebp)
	movl	8(%ebp), %eax
	sall	$2, %eax
	addl	$bitmaps.0, %eax
	movl	%eax, -20(%ebp)
	movl	16(%ebp), %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$6, %eax
	movl	%eax, %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	addl	%eax, -16(%ebp)
	movl	$0, -8(%ebp)
	jmp	.L9
.L13:
	movl	$0, -12(%ebp)
	jmp	.L10
.L12:
	movl	-12(%ebp), %edx
	movl	-20(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	movb	%al, -21(%ebp)
	movsbl	-21(%ebp), %edx
	movl	-8(%ebp), %eax
	movl	$128, %ebx
	movl	%eax, %ecx
	sarl	%cl, %ebx
	movl	%ebx, %eax
	andl	%edx, %eax
	testl	%eax, %eax
	je	.L11
	movl	-12(%ebp), %edx
	movl	-16(%ebp), %eax
	addl	%edx, %eax
	movl	20(%ebp), %edx
	movb	%dl, (%eax)
.L11:
	addl	$1, -12(%ebp)
.L10:
	cmpl	$3, -12(%ebp)
	jle	.L12
	addl	$320, -16(%ebp)
	addl	$1, -8(%ebp)
.L9:
	cmpl	$7, -8(%ebp)
	jle	.L13
	movl	$0, %eax
	movl	-4(%ebp), %ebx
	leave
	ret
	.size	print, .-print
	.type	in8, @function
in8:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	8(%ebp), %eax
	movl	%eax, %edx
/APP
/  155 "keyboard.c" 1
	mov $0, %eax
	in %dx,%al
/  0 "" 2
/NO_APP
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	leave
	ret
	.size	in8, .-in8
	.type	out8, @function
out8:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %edx
	movl	12(%ebp), %eax
/APP
/  164 "keyboard.c" 1
	out %al,%dx
/  0 "" 2
/NO_APP
	movl	$0, %eax
	popl	%ebp
	ret
	.size	out8, .-out8
	.type	sti, @function
sti:
	pushl	%ebp
	movl	%esp, %ebp
/APP
/  173 "keyboard.c" 1
	sti
/  0 "" 2
/NO_APP
	movl	$0, %eax
	popl	%ebp
	ret
	.size	sti, .-sti
	.type	cli, @function
cli:
	pushl	%ebp
	movl	%esp, %ebp
/APP
/  180 "keyboard.c" 1
	cli
/  0 "" 2
/NO_APP
	movl	$0, %eax
	popl	%ebp
	ret
	.size	cli, .-cli
	.type	halt, @function
halt:
	pushl	%ebp
	movl	%esp, %ebp
/APP
/  187 "keyboard.c" 1
	hlt
/  0 "" 2
/NO_APP
	movl	$0, %eax
	popl	%ebp
	ret
	.size	halt, .-halt
	.type	sti_and_halt, @function
sti_and_halt:
	pushl	%ebp
	movl	%esp, %ebp
/APP
/  195 "keyboard.c" 1
	sti
	hlt
/  0 "" 2
/NO_APP
	movl	$0, %eax
	popl	%ebp
	ret
	.size	sti_and_halt, .-sti_and_halt
	.data
	.align 32
	.type	bitmaps.0, @object
	.size	bitmaps.0, 40
bitmaps.0:
	.ascii	"~\201\201~"
	.string	""
	.ascii	"A\377\001"
	.ascii	"C\205\211s"
	.ascii	"B\221\221n"
	.ascii	"\370\b\377\b"
	.ascii	"\362\221\221\216"
	.ascii	">I\221\216"
	.ascii	"\200\217\260\300"
	.ascii	"n\221\221n"
	.ascii	"q\211\222|"
	.ident	"GCC: (GNU) 12.2.0"
