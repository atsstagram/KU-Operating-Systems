.org 0x8200
	.file	"boot2.c"
	.text
	.globl	boot2
	.type	boot2, @function
boot2:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$655360, -12(%ebp)
	addl	$3200, -12(%ebp)
	jmp	.L2
.L3:
	movl	-12(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -12(%ebp)
	movb	$15, (%eax)
.L2:
	movl	-12(%ebp), %eax
	cmpl	$659199, %eax
	jle	.L3
	addl	$2560, -12(%ebp)
	jmp	.L4
.L5:
	movl	-12(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -12(%ebp)
	movb	$15, (%eax)
.L4:
	movl	-12(%ebp), %eax
	cmpl	$662399, %eax
	jle	.L5
	addl	$2560, -12(%ebp)
	jmp	.L6
.L7:
	movl	-12(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -12(%ebp)
	movb	$15, (%eax)
.L6:
	movl	-12(%ebp), %eax
	cmpl	$665599, %eax
	jle	.L7
	addl	$2560, -12(%ebp)
	jmp	.L8
.L9:
	movl	-12(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -12(%ebp)
	movb	$15, (%eax)
.L8:
	movl	-12(%ebp), %eax
	cmpl	$668799, %eax
	jle	.L9
	call	halt
	nop
	leave
	ret
	.size	boot2, .-boot2
	.type	halt, @function
halt:
	pushl	%ebp
	movl	%esp, %ebp
.L11:
	jmp	.L11
	.size	halt, .-halt
	.ident	"GCC: (GNU) 12.2.0"
