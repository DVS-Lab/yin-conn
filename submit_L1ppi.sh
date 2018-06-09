#!/bin/bash


for subj in 100408 100206 100307; do
  for RUN in LR RL; do
    for H in R L; do
      for PPItype in full partial; do
        for PPIseed in V1 OFA FFA ATL pSTS IFG AMG OFC PCC; do

          #Manages the number of jobs and cores
          SCRIPTNAME=L1ppi.sh
          NCORES=24
          while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
            sleep 1m
          done
          bash $SCRIPTNAME $RUN $subj $H $PPIseed $PPItype &
          sleep 5s

        done
      done
    done
  done
done
