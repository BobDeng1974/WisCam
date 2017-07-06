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

SOURCES = audio_demo.c  record_adc_demo.c

OBJS = $(SOURCES:.c=.o)

all:	audio_demo  record_adc_demo

audio_demo:	audio_demo.o
	$(CC) -o $@ $^ $(LDFLAGS) $(LIBS)

record_adc_demo: record_adc_demo.o
	$(CC) -o $@ $^ $(LDFLAGS) $(LIBS)

clean:
	rm -f $(OBJS) audio_demo record_adc_demo
