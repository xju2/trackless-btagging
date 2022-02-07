#!/bin/bash

if [ $# -lt 7 ]; then
	echo "Usage: $0 ACTION ACTS-BIN-DIR OUTPUT-DIR PY8-CMND NEVTS"
	echo "ACTION:       ['gen', 'sim', 'digi', 'meas2sp']"
	echo "ACTS-BIN-DIR: bin-directory created when compiling ACTS"
	echo "OUTPUT-DIR:   output directory"
	echo "PY8-CMD:      py8 commands in a text file"
	echo "NEVTS:        number of events"
	echo "NPU:          number of pileup <mu>"
	echo "SEED:         generator seed"
	exit
fi

#DIGICONF=default-smearing-config-generic.json
DIGICONF=default-geometric-config-generic.json

#DIGICONF=default-input-config-generic.json ## do not use this

if [ ! -f $DIGICONF ];then
	echo "digitization configuration, itk-pixel-digitization.json, does not exist"
	exit
fi

ACTION=$1
ACTSBINDIR=$2 # acts bin directory
OUTDIR=$3	  # output directory
PY8CMD=$4
NEVTS=$5
NPU=$6
SEED=$7

#SHIFTER="shifter --image=docexoty/heptools:ubuntu20.04"
#SHIFTER="docker run --rm -v $PWD:$PWD -w $PWD docexoty/exatrkx:tf2.5-torch1.9-cuda11.2-ubuntu20.04-rapids21.10-devel-hep bash "
SHIFTER=""

if [ ! -d $OUTDIR ];then
	mkdir -p $OUTDIR
fi

CMS=13000
NWORKERS=1
BFIELD="--bf-constant-tesla 0:0:2"

PY8OPTIONS=""
function get_py8_cmd() {
	# pythia configuration
	while IFS= read -r line
	do
		if [ -z "$line" ] || [ ${line:0:1} == "#" ]; then
			continue
		fi
		ARG=${line%%!*}
		ARG=`echo "$ARG" | xargs`
		#echo $ARG
		PY8OPTIONS="$PY8OPTIONS --gen-hard-process \"$ARG\""
	done < $PY8CMD

	echo "$PY8OPTIONS"
}

# generate events
# xy-std, 0.0125 mm
# z-std,  55.5 mm
function gen() {
	get_py8_cmd 

	$SHIFTER $ACTSBINDIR/ActsExamplePythia8 --gen-npileup $NPU --gen-cms-energy-gev $CMS \
		--gen-nhard 1 --rnd-seed $SEED  --gen-pdg-beam0 2212 --gen-pdg-beam1 2212 \
		--output-dir "$OUTDIR" --output-csv -j $NWORKERS -n $NEVTS \
		--gen-hard-process "Random:setSeed = on" --gen-hard-process "Random:seed = 1234" --gen-hard-process "HardQCD:all = on" --gen-hard-process "PhaseSpace:pTHatMin = 25." --gen-hard-process "Tune:ee = 7" --gen-hard-process "PDF:pSet = 13" --gen-hard-process "ColourReconnection:range = 1.71" --gen-hard-process "ParticleDecays:limitTau0 = on" --gen-hard-process "StandardModel:sin2thetaW = 0.23113" --gen-hard-process "StandardModel:sin2thetaWbar = 0.23146" --gen-hard-process "SpaceShower:pTmaxMatch = 1" --gen-hard-process "SpaceShower:pTmaxFudge = 1" --gen-hard-process "SpaceShower:MEcorrections = off" --gen-hard-process "TimeShower:pTmaxMatch = 1" --gen-hard-process "TimeShower:pTmaxFudge = 1" --gen-hard-process "TimeShower:MEcorrections = off" --gen-hard-process "TimeShower:globalRecoil = on" --gen-hard-process "TimeShower:limitPTmaxGlobal = on" --gen-hard-process "TimeShower:nMaxGlobalRecoil = 1" --gen-hard-process "TimeShower:globalRecoilMode = 2" --gen-hard-process "TimeShower:nMaxGlobalBranch = 1." --gen-hard-process "TimeShower:weightGluonToQuark=1." --gen-hard-process "Check:epTolErr = 1e-2" --gen-hard-process "SpaceShower:rapidityOrder = on" --gen-hard-process "SigmaProcess:alphaSvalue = 0.140" --gen-hard-process "SpaceShower:pT0Ref = 1.56" --gen-hard-process "SpaceShower:pTdampFudge = 1.05" --gen-hard-process "SpaceShower:alphaSvalue = 0.127" --gen-hard-process "TimeShower:alphaSvalue = 0.127" --gen-hard-process "BeamRemnants:primordialKThard = 1.88" --gen-hard-process "MultipartonInteractions:pT0Ref = 2.09" --gen-hard-process "MultipartonInteractions:alphaSvalue = 0.126"

		#--gen-hard-process 'Random:setSeed = on' --gen-hard-process 'Random:seed = 1234' --gen-hard-process 'HiggsSM:all = on' --gen-hard-process '25:onMode = off' --gen-hard-process '25:onIfAny = 5 -5' --gen-hard-process 'Tune:ee = 7' --gen-hard-process 'PDF:pSet = 13' --gen-hard-process 'ColourReconnection:range = 1.71' --gen-hard-process 'ParticleDecays:limitTau0 = on' --gen-hard-process 'StandardModel:sin2thetaW = 0.23113' --gen-hard-process 'StandardModel:sin2thetaWbar = 0.23146' --gen-hard-process 'SpaceShower:pTmaxMatch = 1' --gen-hard-process 'SpaceShower:pTmaxFudge = 1' --gen-hard-process 'SpaceShower:MEcorrections = off' --gen-hard-process 'TimeShower:pTmaxMatch = 1' --gen-hard-process 'TimeShower:pTmaxFudge = 1' --gen-hard-process 'TimeShower:MEcorrections = off' --gen-hard-process 'TimeShower:globalRecoil = on' --gen-hard-process 'TimeShower:limitPTmaxGlobal = on' --gen-hard-process 'TimeShower:nMaxGlobalRecoil = 1' --gen-hard-process 'TimeShower:globalRecoilMode = 2' --gen-hard-process 'TimeShower:nMaxGlobalBranch = 1.' --gen-hard-process 'TimeShower:weightGluonToQuark=1.' --gen-hard-process 'Check:epTolErr = 1e-2' --gen-hard-process 'SpaceShower:rapidityOrder = on' --gen-hard-process 'SigmaProcess:alphaSvalue = 0.140' --gen-hard-process 'SpaceShower:pT0Ref = 1.56' --gen-hard-process 'SpaceShower:pTdampFudge = 1.05' --gen-hard-process 'SpaceShower:alphaSvalue = 0.127' --gen-hard-process 'TimeShower:alphaSvalue = 0.127' --gen-hard-process 'BeamRemnants:primordialKThard = 1.88' --gen-hard-process 'MultipartonInteractions:pT0Ref = 2.09' --gen-hard-process 'MultipartonInteractions:alphaSvalue = 0.126'
}


# simulation
function sim() {
	$SHIFTER $ACTSBINDIR/ActsExampleFatrasGeneric --input-dir "$OUTDIR" \
		--output-dir "$OUTDIR" $BFIELD --output-csv -j $NWORKERS
}

# digitization
function digi() {
	$SHIFTER $ACTSBINDIR/ActsExampleDigitizationGeneric $BFIELD --output-dir $OUTDIR \
		--output-csv --input-dir $OUTDIR \
		--digi-config-file $DIGICONF -j $NWORKERS
}

# measurements to spacepoints
function meas2sp() {
	$SHIFTER $ACTSBINDIR/ActsExampleMeasurementsToSPGeneric $BFIELD --output-dir $OUTDIR \
		--output-csv --input-dir $OUTDIR -j $NWORKERS
}

$ACTION

#get_py8_cmd
