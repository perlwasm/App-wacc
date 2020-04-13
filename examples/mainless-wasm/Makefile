CC=wacc
CFLAGS=
LDFLAGS=--no-standard-libraries -Wl,--export-all -Wl,--no-entry

foo.wat : foo.wasm
	wasm2wat foo.wasm > foo.wat

foo.wasm : foo.c
	wacc $(LDFLAGS) -o foo.wasm foo.c


clean:
	rm -f foo.wat foo.wasm
