# MapPred Standalone Package

## 0. software required
tensorflow
keras
python2 or python3
numpy

blast-2.2.26
psipred-4.01
metapsicov-1.04

hhsuite-3.0.0
hmmer-3.1b2-linux-intel-x86_64

CCMpred 

## 1. download the package
git clone https://github.com/AtlasWuqi/mappred.git

## 2. compile
NOTICE: This step can be skipped if the OS is Ubuntu.
cd src/
make
make install
cd ../

## 4. Database required
Uniclust30, Uniref100 and Metagenome for MSA generator.
nr for SS and SOLV.

## 5. configuration
specify the directory of softwares or databases in files: jackhmmer.sh msa-generator.sh runpsipredandsolv mappred.sh

jackhmmer.sh and msa-generator.sh can be ignored if the MSA of a sequence is provided.
runpsipredandsolv can be ignored if the SS and SOLV of a sequence are provided.
mappred.sh can be ignored if the CCMpred result of a sequence is provided.


## 6. Get started
usage: bin/mappred fastafile
example: ./bin/mappred ./example/1NH2C.fasta
output: ./example/1NH2C.mappred

a example can be found in file: ./start.sh

## Reference
Qi Wu 1 , Zhenling Peng 2, * , Ivan Anishchenko 3, 4 , Qian Cong 3, 4 , Jianyi Yang 1,* Protein contact prediction using metagenome sequence data and residual neural networks, Bioinformatics, submitted (2018).

## License
This software is free for non-commercial use. For commercial use, a software agreement is required.

## Feedback
Welcome to send the email to wuqird@aliyun.com, if you have any question about the Mappred.
