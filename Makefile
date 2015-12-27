all: buildall

buildall: buildgo buildruby

buildgo:
	go build -o librubby.a -buildmode=c-shared

buildruby:
	cd gubby/ext && ruby extconf.rb
	cd gubby/ext && make

test: buildall
	cd gubby/ext && rake

cleango:
	rm librubby.a librubby.h 

cleanruby:
	cd gubby/ext && make clean
	cd gubby/ext && rm Makefile

clean: cleango cleanruby
