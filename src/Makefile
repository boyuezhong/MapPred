######################################################################
#	Makefile for MapPred                                         #
######################################################################

#### CC		Command to execute C compiler
#### CFLAGS	Flags to pass to C compiler.

INCDIR		= .
CC		= cc

CFLAGS		= -O
LIBS		= -lm

all:		cov231stats

install:
		/bin/cp -f cov231stats ../bin

clean:
		/bin/rm -f cov231stats *.o

cov231stats:	cov231stats.c
		$(CC) $(CFLAGS) cov231stats.c $(LIBS) -o cov231stats
