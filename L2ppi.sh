#!/bin/bash

# change these paths (should be the only paths you need to change)
basedir=`pwd` # currently the GitHub repo
MAINDATADIR=${basedir}/data # base directory for your input data
MAINOUTPUTDIR=${basedir}/fsl # base directory for your ouput results


#inputs for the script
task=WM
subj=$1
H=$2
PPIseed=$3
PPItype=$4 # full (all ROI regressors) or partial (only seed ROI regressor)

datadir=${MAINDATADIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}
OUTPUTDIR=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}

INPUT1=${OUTPUTDIR}/L1_${task}_LR_PPIseed-${H}-${PPIseed}_${PPItype}.feat
INPUT2=${OUTPUTDIR}/L1_${task}_RL_PPIseed-${H}-${PPIseed}_${PPItype}.feat

# delete old output if it's there to avoid +.feat directories. could improve this.
OUTPUT=${OUTPUTDIR}/L2_${task}_PPIseed-${H}-${PPIseed}_${PPItype}
if [ -d ${OUTPUT}.gfeat ]; then
	rm -rf ${OUTPUT}.gfeat
	echo "deleting existing output"
fi

ITEMPLATE=${basedir}/templates/L2_ppi_${PPItype}.fsf
OTEMPLATE=${OUTPUTDIR}/L2_task_PPIseed-${H}-${PPIseed}_${PPItype}.fsf
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@INPUT1@'$INPUT1'@g' \
-e 's@INPUT2@'$INPUT2'@g' \
<$ITEMPLATE> ${OTEMPLATE}
feat ${OTEMPLATE}

if [ "$PPItype" == "full" ]; then
	NCOPES=27
elif [ "$PPItype" == "partial" ]; then
	NCOPES=19
fi

for COPE in `seq ${NCOPES}`; do
	rm -rf ${OUTPUT}.gfeat/cope${COPE}.feat/filtered_func_data.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${COPE}.feat/stats/res4d.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${COPE}.feat/stats/corrections.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${COPE}.feat/stats/threshac1.nii.gz
done
