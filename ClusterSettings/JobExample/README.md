This is example script to submit the job. For more details, there are some good instructions:
- https://docs.pace.gatech.edu/software/PBS_script_guide/
- https://www.weizmann.ac.il/chemistry/chemfarm/pbs-job-submission
- https://latisresearch.umn.edu/creating-a-PBS-script


- To submit the job, do following:
```sh
qsub JobScript.sh

```

- To see the job status, run this command:
```sh
qstat -taw
```
  or
```sh
qstat -1Jwnt
```

- To delete all your job, run this command:
```sh
qselect -u <username> | xargs qdel
```
  or you can specify the job id, for example:
```sh
qdel 1002[]
```
  or even with job array id:
```sh
qdel 1042[24]
```

- You can get the number of current running jobs by:
```sh
qstat -tw | grep -c "R workq"
```
  or:
```sh
qstat -Q
```
