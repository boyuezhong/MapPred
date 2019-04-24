# MapPred

## 0. Requirements
* Tensorflow (1.6+)<br />
* [Keras](https://keras.io/) (2.1.3+)<br />
* Python (2.7+ or 3.5+) <br />
* Numpy <br />
* h5py <br />
* [PSIPRED](http://bioinfadmin.cs.ucl.ac.uk/downloads/psipred/) <br />
* [solvpred](http://bioinfadmin.cs.ucl.ac.uk/downloads/MetaPSICOV/) <br />
* [CCMpred](https://github.com/soedinglab/CCMpred) <br />

## 1. Download the package
git clone https://github.com/AtlasWuqi/MapPred.git <br />

## 2. Compile
NOTICE: This step can be skipped if the OS is Ubuntu. <br />
cd src <br />
make <br />
make install <br />
cd .. <br />

## 3. Get started
usage: ./bin/mappred.sh alnfile [outputfile] [cuda] <br />
example: ./bin/mappred.sh ./example/1NH2C.aln <br />
### Input:
* xxx.ss2     : secondary structure predicted by PSIPRED
* xxx.solv    : relative solvent accessibility predicted by solvpred
* xxx.ccmpred : contact map predicted by CCMpred
* xxx.aln     : multiple sequence alignments(MSA) 
Format Requirement for an MSA: 
Please check out the example file (./example/1NH2C.aln) for a reference
Each line in the MSA is the protein primary sequence. All the sequences shall have the same length when gaps are also counted. The first protein sequence is the target for which you would like to predict contacts. It shall not contain any gaps. The other protein sequences may contain gaps represented by '-'.
NOTICE: make sure .ss2 .solv .ccmpred ready under the same directory of .aln
<br />
### Output:
* xxx.mappred    : final contact map predicted by DeepMeta [text format]
* xxxdeepmsa.npy : contact map predicted by DeepMSA [Numpy format]
* xxx.231stats   : compressed covar matrices computed from the covariance matrices of the MSA
* xxx.frobstats  : frobenius norm matrice computed from the covariance matrices of the MSA
<br />
a example can be found in file: ./start.sh<br />
you can check the outputfile run by yourself and ./example/1NH2C.mappred.

## Reference
Q Wu, Z Peng, I Anishchenko, Q Cong, D Baker, J Yang, Protein contact prediction using metagenome sequence data and residual neural networks, Bioinformatics, submitted (2018).
