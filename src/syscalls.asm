SYS_read 	= 0
SYS_write	= 1
SYS_open	= 2
SYS_close	= 3
SYS_ioctl	= 16
SYS_exit	= 60

STDIN		= 0
STDOUT		= 1
STDERR		= 2

O_RDONLY	= 0

macro syscall number {
	mov eax, number
	syscall
}
macro exit c {
	mov edi, c
	syscall SYS_exit
}

macro write fd, buffer, len {
	mov edi, fd
	mov rsi, buffer
	mov edx, len
	syscall SYS_write
}

macro read fd, buffer, len {
	mov edi, fd
	mov rsi, buffer
	mov edx, len
	syscall SYS_read
}

macro open path, flags {
	mov rdi, path
	mov esi, flags
	syscall SYS_open
}

macro close fd {
	mov edi, fd
	syscall SYS_close
}

macro ioctl fd, op, argp {
	mov edi, fd
	mov esi, op
	mov rdx, argp
	syscall SYS_ioctl
}

