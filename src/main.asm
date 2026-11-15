format ELF64 executable 3
entry _start

include "src/utils.asm"
include "src/syscalls.asm"
include "src/terminal.asm"
include "src/var.asm"

segment readable executable
include "src/file.asm"

_start:
	xor edi, edi
	cmp qword [rsp], 2
	jb .load_strings
	mov rdi, [rsp + 16]

.load_strings:
	call load_strings
	jc .error

	term_init
	print bnuy_greet

.game_loop:
	cmp r8, r13
	jae .exit

	mov r12b, [r8]

	mov rdi, r8
	call strlen

	print color_red
	print r8, r9d
	print CR
	print color_white

.typing_loop:
	test r12b, r12b
	jz .str_completed

	input inputbuf

	cmp [inputbuf], 27
	je .exit

	cmp [inputbuf], r12b
	je .equal

	print BEL
	jmp .typing_loop

.equal:
	print inputbuf
	inc r8
	mov r12b, [r8]
	jmp .typing_loop

.str_completed:
	inc r8

	print CR
	print NL
	jmp .game_loop

.error:
	exit 1
.exit:
	print bnuy_goodbye
	term_cleanup
	exit 0

strlen:
	xor eax, eax
	mov rcx, -1
	repnz scasb
	not rcx
	dec rcx
	mov r9, rcx
	ret

