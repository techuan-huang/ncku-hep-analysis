This is example script to submit the job.

- To submit the job, do following:
```sh
qsub JobScript.sh

```

- To see the job status, run this command:
```sh
qstat -taw
```

- To delete all your job, run this command:
```sh
qselect -u <username> | xargs qdel
```
Or you can specify the job id, for example:
```sh
qdel 1002[]
```

- You can get the number of current running jobs by:
```sh
qstat -tw | grep -c "R workq"
```
