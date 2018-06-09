#!/bin/bash

# This script will apply a 200 s highpass filter
# This is done to ensure the input timecourses for the PPI analyses have been filtered
# Simply checking the "apply highpass filter" box in Feat does not apply the filter before calculating the interaction

for subj in 100408 100206 100307; do
	for RUN in LR RL; do

		# Manages the number of jobs and cores
		SCRIPTNAME=runFilter.sh
		NCORES=24
		while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
	  		sleep 1m
		done

		bash $SCRIPTNAME $RUN $subj &
		sleep 5s

	done
done
