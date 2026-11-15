struc termios {
	.c_iflag dd ?
	.c_oflag dd ?
	.c_cflag dd ?
	.c_lflag dd ?
	.c_line  db ?
	.c_cc    rb 19
}

TCGETS = 0x5401
TCSETS = 0x5402

VMIN  = 6
VTIME = 5

macro term_init {
	local .error, .done
	ioctl STDIN, TCGETS, original_termios
	test rax, rax
	js .error

	cld
	mov rsi, original_termios
	mov rdi, raw_termios
	mov ecx, 36
	rep movsb

	and dword [raw_termios.c_lflag], 0xffff7ff4
	and dword [raw_termios.c_iflag], 0xfffffa14
	and dword [raw_termios.c_oflag], 0xfffffffe

	mov byte [raw_termios.c_cc + VMIN], 1
	mov byte [raw_termios.c_cc + VTIME], 0

	ioctl STDIN, TCSETS, raw_termios

	jmp .done
	.error: exit 1
	.done:
}

macro term_cleanup {
	ioctl STDIN, TCSETS, original_termios
}
