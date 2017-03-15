UNAME   = $(shell uname)

CC		= g++
ifeq ($(findstring CYGWIN, $(UNAME)), CYGWIN)
	CC	= G++-4
endif

#CFLAGS	= -O3 -c -Wall -Wuninitialized -Wfatal-errors
CFLAGS	= -g -c -Wall
#SRC		= impulse.cpp core/value.cpp core/frame.cpp protos/symbol.cpp
SRC		= $(wildcard *.cpp) $(wildcard core/*.cpp) $(wildcard protos/*.cpp)
#OBJS	= impulse.o core/value.o core/frame.o protos/symbol.o
OBJS	= $(SRC:.cpp=.o)

all: impulse

impulse: $(OBJS)
	$(CC) -o impulse $(OBJS) $(LIBS)

.cpp.o:
	$(CC) $(CFLAGS) -o $@ $< 
.dep: $(wildcard *.cpp) $(wildcard *.h)
	$(CC) -MM $(SRC) > .dep

-include .dep

install: impulse
	cp impulse /usr/local/bin

clean:
	rm -f impulse impulse.exe $(OBJS) .dep trace.log
	rm -f *~ core/*~ protos/*~ parser/*~

lines:
	cat *.cpp *.h core/*.cpp core/*.h parser/*.h protos/*.cpp protos/*.h | wc -l
#	cat *.cpp *.h core/*.cpp core/*.h parser/*.h protos/*.cpp protos/*.h | grep "[#();]" | wc -l
#	cat *.cpp *.h core/*.cpp core/*.h parser/*.h protos/*.cpp protos/*.h | grep -v "^$\|^[ ]*//\|^[ ]*{\|^[ ]*}" | wc -l
	cat *.cpp *.h core/*.cpp core/*.h parser/*.h protos/*.cpp protos/*.h | tr -d "\r" | grep -f greplines | wc -l

