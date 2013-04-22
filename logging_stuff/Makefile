CC=g++
LOG4CPP=`pkg-config --cflags --libs log4cpp`

all: simple properties

prep:
	@mkdir -p tmp
	
simple: prep
	@$(CC) -c -o tmp/simple.o simple.cpp
	@$(CC) $(LOG4CPP) -pthread -o simple tmp/simple.o

properties: prep
	@$(CC) -c -o tmp/properties.o properties.cpp
	@$(CC) $(LOG4CPP) -pthread -o properties tmp/properties.o

clean:
	@rm -rf tmp/ simple properties

