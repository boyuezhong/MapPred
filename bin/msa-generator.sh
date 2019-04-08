#!/bin/bash
pdir=`dirname $0`
gitdir=/dl/wuqi/git
export HHLIB=${gitdir}/hhsuite
evalue=1e-3
coverage=50
cpu=1
[ $# -lt 1 ] && exit
[ $# -ge 2 ] && cpu=$2

target=$1
hhbname=${target}-hhb-${evalue}-${coverage}
uniname=${target}-uni-${evalue}-${coverage}
meta50=${target}-m50-${evalue}-${coverage}
mername=${target}-mer-${evalue}-${coverage}
xneff=3

function search_uniclust30()
{
	if [ ! -s ${hhbname}.aln ] ; then
		$gitdir/hhsuite/bin/hhblits -i ${target}.fasta -d /library/uniclust30/uniclust30_2018_08 \
		-cpu ${cpu} -oa3m ${hhbname}.a3m -ohhm ${hhbname}.hhm -n 3 -maxfilt 500000 -diff inf -id 99 \
		-cov ${coverage} -e ${evalue} > ${hhbname}.hhblog
		[ ! -s ${hhbname}.a3m ] && echo "error generating ${hhbname}.a3m, quit" && exit
		egrep -v "^>" ${hhbname}.a3m | sed 's/[a-z]//g' > ${hhbname}.aln
	fi
	[ ! -s ${hhbname}.aln  ] && echo "[error] generating ${hhbname}.aln, quit" && exit
	[ ! -s ${hhbname}.neff ] &&       ${pdir}/neff ${hhbname}.aln ${hhbname}.neff
	[ ! -s ${hhbname}.neff ] && echo "[error] generating ${hhbname}.neff, quit" && exit
}

function search_uniref100()
{
        [ ! -s ${uniname}.aln  ] &&  touch ${uniname}.aln && ${pdir}/jackhmmer.sh ${target} ${evalue} ${coverage} 0 ${cpu}
        [ ! -s ${uniname}.aln  ] && echo "[error] generating ${uniname}.aln, quit" && exit

	[ ! -s ${uniname}.mer.aln  ] && awk 'BEGIN{que=0}{if(NR==1){que=$0}else{a[$0]+=1}}END{print que; for(e in a){print e}}' \
	${uniname}.aln > ${uniname}.mer.aln
        [ ! -s ${uniname}.mer.aln  ] && echo "[error] generating ${uniname}.mer.aln, quit" && exit
        [ ! -s ${uniname}.neff ] &&      ${pdir}/neff ${uniname}.mer.aln ${uniname}.neff
        [ ! -s ${uniname}.neff ] && echo "[error] generating ${uniname}.neff, quit" && exit
}

function search_metaclust50()
{
        [ ! -s ${meta50}.aln  ] &&  touch ${meta50}.aln && ${pdir}/jackhmmer.sh ${target} ${evalue}  ${coverage} 1 ${cpu}
	[ ! -s ${meta50}.aln  ] && echo "[error] generating ${meta50}.aln, quit" && exit
	[ ! -s ${meta50}.mer.aln  ] && awk 'BEGIN{que=0}{if(NR==1){que=$0}else{a[$0]+=1}}END{print que; for(e in a){print e}}' \
	${meta50}.aln > ${meta50}.mer.aln
	[ ! -s ${meta50}.mer.aln  ] && echo "[error] generating ${meta50}.mer.aln, quit" && exit
	[ ! -s ${meta50}.neff ] &&	${pdir}/neff ${meta50}.mer.aln ${meta50}.neff
	[ ! -s ${meta50}.neff ] && echo "[error] generating ${meta50}.neff, quit" && exit
}

function merge_msa()
{
	[ ! -s ${mername}.aln ] && awk 'BEGIN{que=0}{if(NR==1){que=$0}else{a[$0]+=1}}END{print que; for(e in a){print e}}' \
	${uniname}.mer.aln ${meta50}.mer.aln > ${mername}.aln
	[ ! -s ${mername}.aln ] && echo "[error] generating ${mername}.aln, quit" && exit
	[ ! -s ${mername}.neff ] &&      ${pdir}/neff ${mername}.aln ${mername}.neff
	[ ! -s ${mername}.neff ] && echo "[error] generating ${mername}.neff, quit" && exit
}

if [ ! -s ${target}.aln ] ; then
	search_uniclust30
	seqlen=`head -n 1 ${hhbname}.aln|wc -L`
	((threshold=xneff*seqlen))
	heff=`head -n 3 ${hhbname}.neff|tail -1`

	#return MSA generated by searching uniclust30
	if [ ${heff} -ge ${threshold} ] ; then
		cp ${hhbname}.aln ${target}.aln && cp ${hhbname}.neff ${target}.neff
	else
		search_uniref100
		ueff=`head -n 3 ${uniname}.neff|tail -1`

		#return MSA generated by searching uniref100
		if [ ${ueff} -ge ${threshold} ] ; then
        	        cp ${uniname}.mer.aln ${target}.aln && cp ${uniname}.neff ${target}.neff
	        else
			search_metaclust50
			meff=`head -n 3 ${meta50}.neff|tail -1`

			#return MSA generated by searching metaclust50
			if [ ${meff} -ge ${threshold} ] ; then
				cp ${meta50}.mer.aln ${target}.aln && cp ${meta50}.neff ${target}.neff
	                else
			#merge MSAs from uniref100 and metaclust50, and compare the merged MSA with MSA from uniclust30
				merge_msa
				mergedeff=`head -n 3 ${mername}.neff|tail -1`
				if [ ${mergedeff} -gt ${heff} ] ; then
					cp ${mername}.aln ${target}.aln && cp ${mername}.neff ${target}.neff
				else
					cp ${hhbname}.aln ${target}.aln && cp ${hhbname}.neff ${target}.neff
				fi
			fi
		fi
	fi
fi