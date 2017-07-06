# Generated automatically from Makefile.in by configure.
# $Id: Makefile.in,v 1.59 2002/03/24 22:20:19 jnelson Exp $

.SUFFIXES:
.SUFFIXES: .o .c
.PHONY: clean all


GCC_FLAGS = -Wstrict-prototypes -Wpointer-arith -Wcast-align -Wcast-qual\
  -Wtraditional\
  -Wshadow\
  -Wconversion\
  -Waggregate-return\
  -Wmissing-prototypes\
  -Wnested-externs\
  -Wall \
  -Wundef -Wwrite-strings -Wredundant-decls -Winline


srcdir = .
VPATH = .:./../extras
LDFLAGS =  -g --static
LIBS =  
CFLAGS = -g -O2 -pipe -Wall -I.

# Change these if necessary

CC = arm-linux-gcc 
CPP = arm-linux-gcc -E

SOURCES = gpio_demo.c

OBJS = $(SOURCES:.c=.o)

gpio_demo:	gpio_demo.o
	$(CC) -o $@ $^ $(LDFLAGS) $(LIBS)


clean:
	rm -f $(OBJS) gpio_demo
