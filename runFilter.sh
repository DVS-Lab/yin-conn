#!/bin/bash

# change these paths (should be the only paths you need to change)
basedir=`pwd` # currently the GitHub repo
MAINDATADIR=${basedir}/data # base directory for your input data
MAINOUTPUTDIR=${basedir}/fsl # base directory for your ouput results


#inputs for the script
task=WM
run=$1
subj=$2


datadir=${MAINDATADIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}
OUTPUTDIR=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}
mkdir -p $OUTPUTDIR

# delete old output if it's there to avoid +.feat directories. could improve this.
OUTPUT=${OUTPUTDIR}/filtered
if [ -d ${OUTPUT}.feat ]; then
	rm -rf ${OUTPUT}.feat
fi

DATA=${OUTPUTDIR}/smoothing.feat/ICA_AROMA/denoised_func_data_nonaggr.nii.gz
NVOLUMES=`fslnvols ${DATA}`

ITEMPLATE=${basedir}/templates/filter.fsf
OTEMPLATE=${OUTPUTDIR}/filter.fsf
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@DATA@'$DATA'@g' \
-e 's@NVOLUMES@'$NVOLUMES'@g' \
<$ITEMPLATE> ${OTEMPLATE}
feat ${OTEMPLATE}
