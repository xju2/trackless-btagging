#!/bin/bash

ACTS="gen sim digi meas2sp"
CARD="H_bb.cmnd"
for ACT in $ACTS
do
	./run_acts.sh $ACT bin Hbb/Tracks $CARD 5000 0 1234
done
