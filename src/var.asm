segment readable writeable

inputbuf db 0

FILEBUF_SIZE = 65536
filebuf rb FILEBUF_SIZE

original_termios termios
raw_termios termios

segment readable

color_red db 27, "[0;31m"
color_white db 27, "[0;37m"
CR db 13
NL db 10
BEL db 7

words db "hello lil bnuuy", 0, "hop hop hop!", 0, "where are my strawberries?!", 0

bnuy_greet db " (\_/)", 13, 10, " ( o.o)  < ready to type?", 13, 10, " / >🍓", 13, 10, 10, "Type the following:", 13, 10
bnuy_goodbye db 13, 10, " (\_/)", 13, 10, " ( ^3^)  < good job!!", 13, 10, " / >🍓", 13, 10

