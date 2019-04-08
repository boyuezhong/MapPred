#!/bin/bash
pdir=`dirname $0`
name=$1
e=$2
cov=$3
level=$4
cpu=$5

#specify uniref100 and metaclust database.
pref='/dl/wuqi/library/'
dbs=( $pref/uniref100-10.fasta $pref/metaclust_50-10.fasta )
dns=( uni m50 )
db=${dbs[$level]}
dn=${dns[$level]}
prefix=${name}-${dn}-$e
jackhmmer=/dl/wuqi/git/hmmer/binaries/jackhmmer
if [ ! -s ${prefix}.aln ] ; then
	${jackhmmer} --cpu ${cpu} -N 3 -E 10 --incE $e -A ${prefix}.jack --noali ${name}.fasta $db > ${prefix}-jackhmmer.log
	[ ! -s ${prefix}.jack ] && echo "[error] generating ${prefix}.jack" && exit
	${pdir}/reformat.pl -l 2000 -d 2000 sto a3m ${prefix}.jack ${prefix}.a3m
	 egrep -v "^>" ${prefix}.a3m | sed 's/[a-z]//g' > ${prefix}.aln
	[ ! -s ${prefix}.aln ] && echo "[error] generating ${prefix}.aln" && exit
fi
[ ! -s ${prefix}-${cov}.aln ] && ${pdir}/coverage.sh ${prefix} $cov
#rm -rf ${prefix}.a3m ${prefix}.jack ${prefix}-jackhmmer.log
