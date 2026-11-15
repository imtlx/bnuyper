load_strings:
	test rdi, rdi
	jz .builtin

	open rdi, O_RDONLY

	test rax, rax
	js .error

	mov r14, rax
	xor r15d, r15d

.read:
	cmp r15, FILEBUF_SIZE - 1
	jb .read_normal

	lea rax, [filebuf + r15]
	read r14d, rax, 1

	test rax, rax
	js .read_error
	jnz .read_error
	jmp .read_done

.read_normal:
	lea rax, [filebuf + r15]
	mov ebx, FILEBUF_SIZE - 1
	sub ebx, r15d
	read r14d, rax, ebx

	test rax, rax
	js .read_error
	jz .read_done

	add r15, rax
	jmp .read

.read_done:
	close r14d

	mov byte [filebuf + r15], 0

	lea rsi, [filebuf]
	lea rdx, [filebuf + r15]
	lea rdi, [filebuf]
	cld

.next_line:
	cmp rsi, rdx
	jae .parsed
	mov rbx, rsi

.scan_line:
	cmp rsi, rdx
	jae .line_end

	cmp byte [rsi], 10
	je .newline

	inc rsi
	jmp .scan_line

.newline:
	mov r10, rsi
	inc rsi
	jmp .trim

.line_end:
	mov r10, rsi
	jmp .trim

.trim:
	mov r12, rsi

.trim_leading:
	cmp rbx, r10
	jae .skip_line

	cmp byte [rbx], 32
	je .leading_whitespace

	cmp byte [rbx], 9
	je .leading_whitespace

	cmp byte [rbx], 13
	je .leading_whitespace

	jmp .trim_trailing

.leading_whitespace:
	inc rbx
	jmp .trim_leading

.trim_trailing:
	cmp rbx, r10
	jae .skip_line

	cmp byte [r10 - 1], 32
	je .trailing_whitespace

	cmp byte [r10 - 1], 9
	je .trailing_whitespace

	cmp byte [r10 - 1], 13
	je .trailing_whitespace

	jmp .check_comment

.trailing_whitespace:
	dec r10
	jmp .trim_trailing

.check_comment:
	cmp byte [rbx], ';'
	je .skip_line

	mov rsi, rbx
	mov rcx, r10
	sub rcx, rbx
	rep movsb

	mov byte [rdi], 0
	inc rdi

.skip_line:
	mov rsi, r12
	jmp .next_line

.parsed:
	lea r8, [filebuf]
	mov r13, rdi
	clc
	ret

.builtin:
	lea r8, [words]
	lea r13, [words + words.len]
	clc
	ret

.read_error:
	close r14d

.error:
	stc
	ret

