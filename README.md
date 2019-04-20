# MapPred

## 0. Requirements
* tensorflow <br />
* keras<br />
* python (2.x or 3.x) <br />
* numpy <br />
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
NOTICE: make sure .ss2 .solv .ccmpred ready under the same directory of .aln
<br />
a example can be found in file: ./start.sh<br />
you can check the outputfile run by yourself and ./example/1NH2C.mappred.

## Reference
Qi Wu, Zhenling Peng, Ivan Anishchenko, Qian Cong, David Baker, Jianyi Yang, Protein contact prediction using metagenome sequence data and residual neural networks, Bioinformatics, submitted (2018).
