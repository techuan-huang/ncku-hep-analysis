#!/bin/bash
#----------------------------------------------------------
# Job name
#PBS -N Example

# Job array
#PBS -J 1-100

# 1 CPU and 2GB memory per job
#PBS -l select=1:ncpus=1:mem=2GB

# Run time (hh:mm:ss) - 1.5 hours
#PBS -l walltime=01:30:00
#----------------------------------------------------------

JOBID=`echo ${PBS_JOBID} | cut -d'[' -f1`
workDir=/tmp/${USER}_${PBS_JOBNAME}_${JOBID}_${PBS_ARRAY_INDEX}
homeDir=${PBS_O_WORKDIR}

echo "WORKDIR: $workDir"
echo "homeDir: $homeDir"

i_job=${PBS_ARRAY_INDEX}

echo "Sleeping now."

time sleep $(expr $i_job \* 10)

echo "Now, we are at '$(hostname)'!"

mkdir -vp $workDir && cd $workDir

source /home/software/SetupRoot6.sh

echo "Start the Job!"
## Do your job here

rm -rf $workDir
