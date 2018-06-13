#!/bin/bash


for task in REST1 REST2; do
  for subj in 100408 100206 100307; do
    for H in R L; do

      #Manages the number of jobs and cores
      SCRIPTNAME=L2rest.sh
      NCORES=24
      while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
        sleep 1m
      done
      bash $SCRIPTNAME $task $subj $H &
      sleep 5s

    done
  done
done
