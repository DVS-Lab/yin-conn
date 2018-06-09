#!/bin/bash

basedir=`pwd`
MAINDATADIR=${basedir}/data
MAINOUTPUTDIR=${basedir}/fsl


#testing
task=WM
run=$1
subj=$2
H=$3
ROI=$4

datadir=${MAINDATADIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}
OUTPUTDIR=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}
mkdir -p $OUTPUTDIR

OUTPUT=${OUTPUTDIR}/tmp_L1_${task}_${run}_${H}-hemi
DATA=${OUTPUTDIR}/smoothing.feat/ICA_AROMA/denoised_func_data_nonaggr.nii.gz
NVOLUMES=`fslnvols ${DATA}`

maskdir=${basedir}/masks/${subj}
N=0
for roi in V1 OFA FFA ATL pSTS IFG AMG OFC PCC; do
	let N=$N+1
	TSFILE=${OUTPUTDIR}/${H}_${roi}.txt
	fslmeants -i ${DATA} -o $TSFILE -m ${maskdir}/${H}_${roi}.nii
	eval INPUT$N=$TSFILE
done
EVDIR=${datadir}/EVs

D=( 'test1' 'test2' 'test3' 'test4' )
for i in 0 1 2 3; do
  echo $D[$i]
done


#find and replace: run feat for smoothing
ITEMPLATE=${basedir}/templates/L1_ppi_full.fsf
OTEMPLATE=${OUTPUTDIR}/L1_task_${run}_${H}-hemi.fsf
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@DATA@'$DATA'@g' \
-e 's@NVOLUMES@'$NVOLUMES'@g' \
-e 's@INPUT1@'$INPUT1'@g' \
-e 's@INPUT2@'$INPUT2'@g' \
-e 's@INPUT3@'$INPUT3'@g' \
-e 's@INPUT4@'$INPUT4'@g' \
-e 's@INPUT5@'$INPUT5'@g' \
-e 's@INPUT6@'$INPUT6'@g' \
-e 's@INPUT7@'$INPUT7'@g' \
-e 's@INPUT8@'$INPUT8'@g' \
-e 's@INPUT9@'$INPUT9'@g' \
<$ITEMPLATE> ${OTEMPLATE}
feat ${OTEMPLATE}

rm -rf ${OUTPUT}.feat/filtered_func_data.nii.gz
rm -rf ${OUTPUT}.feat/stats/res4d.nii.gz
rm -rf ${OUTPUT}.feat/stats/corrections.nii.gz
rm -rf ${OUTPUT}.feat/stats/threshac1.nii.gz
