PROG = wiscam-server
SSL_LIB ?= openssl
SOURCES = $(PROG).c mongoose.c wiscam-config.c
#CFLAGS = -W -Wall $(CFLAGS_EXTRA)
CFLAGS = -g -W -Wall -Werror -I./ -Wno-unused-function $(CFLAGS_EXTRA)

CC = arm-linux-gcc
CFLAGS += -ldl -lm -pthread -static

all: $(PROG)

$(PROG): $(SOURCES)
	$(CC) $(SOURCES) -o $@ $(CFLAGS)

clean:
	rm -rf *.gc* *.dSYM *.exe *.obj *.o a.out $(PROG)
