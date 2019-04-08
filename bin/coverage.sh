#!/bin/bash
file=$1
cov=$2
awk -v cov=$cov '{ if(NR==1){L=length($0)} cnt=0; for ( i=1; i<=length($0); i++ ){if (substr($0,i,1)=="-")cnt++;}if ( cnt/length($0) <= 1-cov/100 && length($0)==L) {print $0;}}' ${file}.aln > ${file}-${cov}.aln

#awk '{if(NR==1){L=length($0)} if (length($0)!=L){print $0}}' > ${file}-${cov}.aln
