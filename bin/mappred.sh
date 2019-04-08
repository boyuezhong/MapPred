#!/bin/bash
#-------check paras
[ $# -lt 1 ] && echo "usage: ./mappred.sh fastafile" && exit
[ ! -s ] && echo "not found $1 , quit" && exit

#-------set vars
fastapath=`readlink -f $1`
fulnam=`basename $fastapath`
target=${fulnam%.*}
fastadir=`dirname $fastapath`
output=${fastadir}/${target}.mappred
[ -s ${output} ] && echo "${output} existed, quit" && exit

targetdir=$fastadir/mappred
mkdir -p $targetdir
logpath=$targetdir/${target}.log
[ ! -s $targetdir/$target.fasta ] && cp $fastapath $targetdir/$target.fasta

function report()
{
	echo "generate $1 failure, quit"
	exit
}

cd $targetdir
#check existed features and link them to current directory.
for feat in aln ss2 solv ccmpred 231stats frobstats 21stats aln.21stats ; do
	[ ! -s ${target}.${feat} ] && [ -s ../${target}.${feat} ] && ln -s ../${target}.${feat} ${target}.${feat}
done

pdir=`dirname $0`
totalcpus=`grep 'processor' /proc/cpuinfo|wc -l`
((cpu=totalcpus/2))
modeldir=$pdir/../model/

#Step <1>-----MSA generator : 
#if the MSA is provided, then skipping this step; otherwise, searching the Uniclust30, Uniref100 and Metegenome by order.
[ ! -s ${target}.aln ] && $pdir/msa-generator.sh $target $cpu >> $logpath 2>&1
[ ! -s ${target}.aln ] && report "MSA"

#Step <2>-----SS and SLOV
#if the SS and SOLV is provided, then skipping this step; otherwise, searching the nr database.

[ ! -s ${target}.ss2 ] && ${pdir}/runpsipredandsolv ${target} $cpu >> $logpath 2>&1
[ ! -s ${target}.ss2 ] && report "SS and SOLV"

#Step <3>-----compressed covar matrix
#if the covar matrix is provided, then skipping this step.
if [ ! -s ${target}.21stats ] && [ ! -s ${target}.aln.21stats ] ; then
	[ ! -s ${target}.231stats ] && ${pdir}/cov231stats ${target}.aln ${target}.231stats ${target}.frobstats >> $logpath 2>&1
	[ ! -s ${target}.231stats ] && report "compressed covar matrix"
else
	echo "covar matrix existed, skip"
fi

#Step <4>-----CCMpred
if [ ! -s ${target}.ccmpred ] ; then
	cuda=`python $pdir/gpustatus.py -n 1`
	#The program will search gpus available firstly, if there are no gpus available in the machine, then switch to cpus.
	if [ $cuda -ne "-1" ] ; then
		${pdir}/ccmpred -d $cuda  ${target}.aln ${target}.ccmpred >> $logpath 2>&1
	else
		${pdir}/ccmpred -d -1 -t ${cpu} ${target}.aln ${target}.ccmpred >> $logpath 2>&1
	fi
	[ ! -s ${target}.ccmpred ] && ${pdir}/ccmpred -d -1 -t $cpu ${target}.aln ${target}.ccmpred >> $logpath 2>&1
fi
[ ! -s ${target}.ccmpred ] && report "CCMpred"

#Step <5>-----DeepMSA and DeepMeta
if [ ! -s ${target}.mappred ] ; then
	cuda=`python $pdir/gpustatus.py -n 1`
	#The program will search gpus available firstly, if there are no gpus available in the machine, then switch to cpus.
	#OOM may be observed when run on the sequence with a big size (1000+), 
	#in the situation, set cuda=0,1 if more than two gpus; otherwise, set cuda=-1
	[ ! -s ${target}.mappred ] && python $pdir/mappred-predictor.py -u $cuda -t $target $targetdir $modeldir >> $logpath 2>&1
fi
[ ! -s ${target}.mappred ] && report "DeepMeta"
cp ${target}.mappred ..

#-----END

