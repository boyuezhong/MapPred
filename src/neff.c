/* MetaPSICOV Alignment Stats Program - by David T. Jones June 2014 */

/* Copyright (C) 2014 University College London */

/* V1.03 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>


#define FALSE 0
#define TRUE 1

#define SQR(x) ((x)*(x))

#define MAXSEQLEN 5000

char  **aln;
int nseqs;

const char     *rescodes = "ARNDCQEGHILKMFPSTWYVXXX";


/* Dump a rude message to standard error and exit */
void
                fail(char *errstr)
{
    fprintf(stderr, "\n*** %s\n\n", errstr);
    exit(-1);
}

/* Convert AA letter to numeric code (0-21) */
int
                aanum(int ch)
{
    const static int aacvs[] =
    {
	999, 0, 3, 4, 3, 6, 13, 7, 8, 9, 21, 11, 10, 12, 2,
	21, 14, 5, 1, 15, 16, 21, 19, 17, 21, 18, 6
    };

    return (isalpha(ch) ? aacvs[ch & 31] : 20);
}

int             main(int argc, char **argv)
{
    int         a, b, c, d, i, j, ii, jj, k, l, n, llen, maxnps=3, posn, qstart, seqlen, endflg = FALSE, tots, maxtots, lstart, nids, s;
    double 	aacomp[21], sumj[21], sum, score, di, pdir, hahb, hx, hy, hxy, mi, mip, z, oldvec[21], change, wtsum, idthresh=0.38, potsum;
    float 	misum[MAXSEQLEN], mimean=0.0, *weight;
    char        buf[4096], name[512], seq[MAXSEQLEN], qseq[160], *cp;
    FILE 	*ifp, *singofp;

    if (argc != 3)
	fail("Usage: neff alnfile singoutfile");

    ifp = fopen(argv[1], "r");
    if (!ifp)
	fail("Unable to open alignment file!");

    for (nseqs=0;; nseqs++)
	if (!fgets(seq, MAXSEQLEN, ifp))
	    break;

    aln = malloc(nseqs * sizeof(char *));
    weight = malloc(nseqs * sizeof(float));

    rewind(ifp);
    
    if (!fgets(seq, MAXSEQLEN, ifp))
	fail("Bad alignment file!");
    
    seqlen = strlen(seq)-1;

    if (!(aln[0] = malloc(seqlen)))
	fail("Out of memory!");

    for (j=0; j<seqlen; j++)
	aln[0][j] = aanum(seq[j]);
    
    for (i=1; i<nseqs; i++)
    {
	if (!fgets(seq, MAXSEQLEN, ifp))
	    break;
	
	if (seqlen != strlen(seq)-1)
	    fail("Length mismatch in alignment file!");
	
	if (!(aln[i] = malloc(seqlen)))
	    fail("Out of memory!");
	
	for (j=0; j<seqlen; j++)
	    aln[i][j] = aanum(seq[j]);
    }

    fclose(ifp);

    /* Calculate sequence weights */
    for (i=0; i<nseqs; i++)
	weight[i] = 1.0;
    
    for (i=0; i<nseqs; i++)
    {
	for (j=i+1; j<nseqs; j++)
	{
	    int nthresh = idthresh * seqlen;
	
//	    N.B. this calculation is slightly off - really this loop should be: nthresh >= 0
//	    Doesn't matter much, but should probably fix this when I next generate new training data
	    for (k=0; nthresh > 0 && k<seqlen; k++)
		if (aln[i][k] != aln[j][k])
		    nthresh--;
	    
	    if (nthresh > 0)
	    {
		weight[i]++;
		weight[j]++;
	    }
	}
    }

    for (wtsum=i=0; i<nseqs; i++)
	wtsum += (weight[i] = 1.0 / weight[i]);

    if (!(singofp = fopen(argv[2], "w")))
	fail("Cannot open sing output file!");

    fprintf(singofp, "%d\n", seqlen);
    fprintf(singofp, "%d\n", nseqs);
    fprintf(singofp, "%d\n", (int)wtsum);
    fclose(singofp);
    
    return 0;
}
