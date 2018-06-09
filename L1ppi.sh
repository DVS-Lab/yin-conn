#!/bin/bash

basedir=`pwd`
MAINDATADIR=${basedir}/data
MAINOUTPUTDIR=${basedir}/fsl


#testing
task=WM
run=$1
subj=$2
H=$3
PPIseed=$4

datadir=${MAINDATADIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}
OUTPUTDIR=${MAINOUTPUTDIR}/${subj}/MNINonLinear/Results/tfMRI_${task}_${run}
mkdir -p $OUTPUTDIR

OUTPUT=${OUTPUTDIR}/tmp_L1_${task}_${run}_${H}-hemi
DATA=${OUTPUTDIR}/smoothing.feat/ICA_AROMA/denoised_func_data_nonaggr.nii.gz
NVOLUMES=`fslnvols ${DATA}`

maskdir=${basedir}/masks/${subj}
N=0
#ROI_list=( V1 OFA FFA ATL pSTS IFG AMG OFC PCC )
if [ "$PPIseed" == "V1" ]; then
	ROI_list=( OFA FFA ATL pSTS IFG AMG OFC PCC )
elif [ "$PPIseed" == "OFA" ]; then
	ROI_list=( V1 FFA ATL pSTS IFG AMG OFC PCC )
elif [ "$PPIseed" == "FFA" ]; then
	ROI_list=( V1 OFA ATL pSTS IFG AMG OFC PCC )
elif [ "$PPIseed" == "ATL" ]; then
	ROI_list=( V1 OFA FFA pSTS IFG AMG OFC PCC )
elif [ "$PPIseed" == "pSTS" ]; then
	ROI_list=( V1 OFA FFA ATL IFG AMG OFC PCC )
elif [ "$PPIseed" == "IFG" ]; then
	ROI_list=( V1 OFA FFA ATL pSTS AMG OFC PCC )
elif [ "$PPIseed" == "AMG" ]; then
	ROI_list=( V1 OFA FFA ATL pSTS IFG OFC PCC )
elif [ "$PPIseed" == "OFC" ]; then
	ROI_list=( V1 OFA FFA ATL pSTS IFG AMG PCC )
elif [ "$PPIseed" == "PCC" ]; then
	ROI_list=( V1 OFA FFA ATL pSTS IFG AMG OFC )
fi

for i in `seq 0 7`; do
	TSFILE=${OUTPUTDIR}/${H}_${roi}_PPIseed-${PPIseed}_roi-${i}.txt
	fslmeants -i ${DATA} -o $TSFILE -m ${maskdir}/${H}_${ROI_list[$i]}.nii
	eval ROI$N=$TSFILE
done
EVDIR=${datadir}/EVs
PHYSTS=${OUTPUTDIR}/${H}_PPIseed-${PPIseed}.txt
fslmeants -i ${DATA} -o $PHYSTS -m ${maskdir}/${H}_${PPIseed}.nii



#find and replace: run feat for smoothing
ITEMPLATE=${basedir}/templates/L1_ppi_full.fsf
OTEMPLATE=${OUTPUTDIR}/L1_task_${run}_PPIseed-${PPIseed}.fsf
sed -e 's@OUTPUT@'$OUTPUT'@g' \
-e 's@DATA@'$DATA'@g' \
-e 's@NVOLUMES@'$NVOLUMES'@g' \
-e 's@ROI1@'$ROI1'@g' \
-e 's@ROI2@'$ROI2'@g' \
-e 's@ROI3@'$ROI3'@g' \
-e 's@ROI4@'$ROI4'@g' \
-e 's@ROI5@'$ROI5'@g' \
-e 's@ROI6@'$ROI6'@g' \
-e 's@ROI7@'$ROI7'@g' \
-e 's@ROI8@'$ROI8'@g' \
-e 's@EVDIR@'$EVDIR'@g' \
<$ITEMPLATE> ${OTEMPLATE}
feat ${OTEMPLATE}

rm -rf ${OUTPUT}.feat/filtered_func_data.nii.gz
rm -rf ${OUTPUT}.feat/stats/res4d.nii.gz
rm -rf ${OUTPUT}.feat/stats/corrections.nii.gz
rm -rf ${OUTPUT}.feat/stats/threshac1.nii.gz
