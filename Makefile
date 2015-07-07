test: build
	erl -s test run

build: clean
	erlc map_reduce.erl map_reduce_test.erl test.erl

clean:
	-rm *.beam
