CXX=g++
CFLAGS=`pkg-config --cflags yajl`
LIBS=`pkg-config --libs yajl`
OBJ= json_reformat.o

%.o: %.cpp
	$(CXX) -c -o $@ $< $(CFLAGS)

json_reformat: $(OBJ)
	$(CXX) -o $@ $^ $(LIBS)

clean:
	rm -f $(OBJ) json_reformat
