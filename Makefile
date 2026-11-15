.PHONY: all clean run

OUT := out/bnuyper

all: $(OUT)

run: $(OUT)
	./$(OUT)

$(OUT): src/*.asm
	mkdir -p out
	fasm src/main.asm $(OUT)
	chmod +x $(OUT)

clean:
	rm -r out

