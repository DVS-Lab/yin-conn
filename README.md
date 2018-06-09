# Connectivity Project

These scripts will help conduct functional and effective connectivity analyses (PPI). We are mainly focusing on the WM task and isolating the face contrasts.

## Resting State Analysis
-Update paths in L1rest.sh
-Test on one subject/run: `bash L1rest.sh REST1 LR 100307 L`
-Update submission script (submit_L1rest.sh) to work with cluster
-TODO: Make L2 script.

## PPI Analyses
For this set of analyses, we have a few more things to consider in terms of preprocessing. Note that you will likely have to install a couple of Python packages to get ICA-AROMA to work on your system.
-Update paths in runAROMA.sh (this smoothes the data and removes motion)
-Update paths in runFilter.sh (this applies a hp filter since AROMA uses unfiltered data)
-Test on one subject/run: `bash runAROMA.sh WM LR 100307`
-Test on one subject/run: `bash runFilter.sh LR 100307`
-Update submission scripts (submit_runAROMA.sh and submit_runFilter.sh) to work with cluster.
-First run `submit_runAROMA.sh` on all data. Then run `submit_runFilter.sh` on all of the outputs of runAROMA.sh. (order here is essential)

Now that the data have been pre-processed in a way that resembles the REST data, we can run our PPI models. For that, we have two basic PPI models. The first one is "full" and includes all of the ROI timecourses (from one hemisphere); and the second one is "partial" and includes only the see region of interest. In my view, the "full" model is what we want since it is closer to the REST analyses and controls for responses in the other regions. Here's how to run it:
-Update paths in L1ppi.sh
-Test on one subject/run: `bash L1ppi.sh LR 100307 L OFC full`
-Update submission script (submit_L1ppi.sh)
-TODO: Make L2 script.
