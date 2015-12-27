# Rubby

This is a POC for using Go's 1.5 ability to be compiled as a shared library  to
extend ruby. 

# What does this POC do?

It is a ruby program that uses the functions in `rubby.go` to push HTTP/S URLs  from
ruby into a go channel using `Gubby.push_url` , once those URLs are pushed if
`Gubby.start` has been called a worker gourutine will GET the URL consuming from
the channel, each of the URLs will be requested by a different goroutine.

I'm aware that the POC is mostly useless becase as of now it does not give any
data back to ruby, also the concurrency  mode is naive and will both exhaust
resources if pushed to hard or deadlock easily. Is not hard to improve all those
things, and I might do it, but that is not the point of this POC.

## Files that matter

### `rubby.go`

Is the go library, it does all the "heavy" lifting starts and stops the
consuming goroutine, it is pretty naive and straigh forward go code, that will
be called from ruby.

### `Makefile`

The builgo task is important it defines easy names for `extconf.rb`'s
`find_library` helpers, also uses `c-shared` as the compilation option, all and
all that means, that `make buildgo` will leave us with `librubby.a` and
`librubby.h` that then can be used on the ruby side.

### `exconf.rb`

Pretty minimal extconf file, it just tries all the go paths for
`/src/github.com/camilo/rubby` and looks for an already built librubby  and it's
header file.

### `gubby/ext/gubby.c`

This is the ruby extension file, uses the librubby header to pass ruby data into
go, and  allow the `Gubby` module to access exported functions, as long as
`librubby.h` is available is pretty straight forward to write wrappers for the
go functions.

###  `gubby/test/gubby_test.rb`

The one place that actually tries to execute all of the above, test are by no
means extensive. Tests can be invoked from the root of the go project using
`make test`.




