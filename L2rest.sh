#!/bin/bash

# change these paths (should be the only paths you need to change)
basedir=`pwd` # currently the GitHub repo
MAINDATADIR=${basedir}/data # base directory for your input data
MAINOUTPUTDIR=${basedir}/fsl # base directory for your ouput results


task=$1
subj=$2
H=$3

datadir=${MAINDATADIR}/${subj}/MNINonLinear/Results/rfMRI_${task}_${run}
OUTPUTDIR=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/rfMRI_${task}_${run}
mkdir -p $OUTPUTDIR

INPUT1=${OUTPUTDIR}/L1_${task}_LR-${H}-hemi.feat
INPUT2=${OUTPUTDIR}/L1_${task}_RL-${H}-hemi.feat

OUTPUT=${OUTPUTDIR}/L2_${task}_${H}-hemi
if [ -d ${OUTPUT}.gfeat ]; then
	rm -rf ${OUTPUT}.gfeat
	echo "deleting existing output"
fi

#find and replace: run feat for smoothing
ITEMPLATE=${basedir}/templates/L2_rest.fsf
OTEMPLATE=${OUTPUTDIR}/L2_rest_${H}-hemi.fsf
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@INPUT1@'$INPUT1'@g' \
-e 's@INPUT2@'$INPUT2'@g' \
<$ITEMPLATE> ${OTEMPLATE}
feat ${OTEMPLATE}

# delete files that aren't necessary
for COPE in `seq 9`; do
	rm -rf ${OUTPUT}.gfeat/cope${COPE}.feat/filtered_func_data.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${COPE}.feat/stats/res4d.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${COPE}.feat/stats/corrections.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${COPE}.feat/stats/threshac1.nii.gz
done
