#!/bin/bash
scrfile=`readlink -f $0`
pdir=`dirname $scrfile`

#-------check paras
[ $# -lt 1 ] && echo "usage: ./mappred.sh alnfile [outputfile]" && exit
[ ! -s $1 ] && echo "not found $1 , quit" && exit

#-------set vars
fastapath=`readlink -f $1`
fulnam=`basename $fastapath`
target=${fulnam%.*}
fastadir=`dirname $fastapath`

#------check outputfile
[ $# -lt 2 ] && output=${fastadir}/${target}.mappred && echo "[info] use the default outputfile: $output"
[ $# -ge 2 ] && output=`readlink -f $2`
[ -s ${output} ] && echo "[warn] ${output} existed, quit" && exit

[ $# -lt 3 ] && cuda=-1
[ $# -ge 3 ] && cuda=$3

#------check intput features
for feat in ss2 solv ccmpred ; do
	featurefile=$fastadir/${target}.${feat}
	[ ! -s ${featurefile} ] && echo "[error] not found ${featurefile}, check it, please" && exit
done

#------create a temp directory
#strtime=`date +%Y%m%d%H%M%S`
targetdir=$fastadir/mappred
mkdir -p $targetdir

cd $targetdir
#link input features to current directory.
[ ! -s $target.aln ] && ln -s $fastapath $target.aln
for feat in ss2 solv ccmpred ; do
	[ ! -s ${target}.${feat} ] && ln -s ../${target}.${feat} ${target}.${feat}
done

#Step <1>-----compressed covar matrix
[ ! -s ${target}.231stats ] && ${pdir}/cov231stats ${target}.aln ${target}.231stats ${target}.frobstats
[ ! -s ${target}.231stats ] && echo "[error] compressed covar matrix, quit" && exit
echo "[info] compressed covar matrix finished"
#Step <2>-----DeepMSA and DeepMeta
[ ! -s ${target}.mappred ] && python $pdir/predictor.py -u $cuda -t $target $targetdir $pdir/../model/
[ ! -s ${target}.mappred ] && echo "[error] generate contact map" && exit
cp ${target}.mappred $output
#rm -rf $targetdir
echo "[info] done $target"
#-----END
