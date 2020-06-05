CC=wacc
CFLAGS=-fPIC
LDFLAGS=-Wl,--no-entry -Wl,--export-dynamic -Wl,--allow-undefined

foo.wat : foo.wasm
	wasm2wat foo.wasm > foo.wat

foo.wasm : foo.c
	wacc $(LDFLAGS) -o foo.wasm foo.c


clean:
	rm -f foo.wat foo.wasm
