######################################################################
#	Makefile for MapPred                                         #
######################################################################

#### CC		Command to execute C compiler
#### CFLAGS	Flags to pass to C compiler.

INCDIR		= .
CC		= cc

CFLAGS		= -O
LIBS		= -lm

all:		neff cov231stats

install:
		/bin/cp -f neff cov231stats ../bin

clean:
		/bin/rm -f neff cov231stats *.o

neff:		neff.c
		$(CC) $(CFLAGS) neff.c $(LIBS) -o neff

cov231stats:	cov231stats.c
		$(CC) $(CFLAGS) cov231stats.c $(LIBS) -o cov231stats
