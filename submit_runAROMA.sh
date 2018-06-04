#!/bin/bash


for task in WM; do
    for subj in 100408 100206 100307; do 
	for RUN in LR RL; do

		#Manages the number of jobs and cores
		SCRIPTNAME=runAROMA.sh
		NCORES=24
		while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
	  		sleep 1m
		done

		bash runAROMA.sh $task $RUN $subj &
		sleep 5s

	done

    done
done



