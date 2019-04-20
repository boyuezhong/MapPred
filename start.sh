#!/bin/bash
cd `dirname $0`
pdir=`pwd`

#usage: mappred.sh alnfile [outputfile] [cuda]
#default outputfile: xxx.mappred
#default cuda: -1 ; set cuda=0 or cuda=0,1 , it will run faster if gpus is available.
$pdir/bin/mappred.sh ./example/1NH2C.aln ./example/1NH2C.mappredv2 2,3
