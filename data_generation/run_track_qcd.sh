#!/bin/bash

ACTS="gen sim digi meas2sp"
CARD="qcd.cmnd"
for ACT in $ACTS
do
	echo "doing $ACT"
	./run_acts.sh $ACT bin QCD/Tracks $CARD 5000 0 1234
done
