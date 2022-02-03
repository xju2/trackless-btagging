To use Delphes
```
docker run -it --rm -v $PWD:$PWD -w $PWD docexoty/heptools:ubuntu20.04 bash

DelphesPythia8 delphes_card_ATLAS.tcl qcd_with_seeds.cmnd Delphe_QCD.root
```

to use ACTS
```
docker run -it --rm -v $PWD:$PWD -w $PWD --gpus all docexoty/exatrkx:tf2.5-torch1.9-cuda11.2-ubuntu20.04-rapids21.10-devel-hep bash

./run_track_qcd.sh
```
