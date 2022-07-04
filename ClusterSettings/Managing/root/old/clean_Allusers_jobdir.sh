#!/bin/bash

for user in $(ls /home/);
do
    echo "Cleaning user: $user ..."
    rocks run host compute "rm -rf /state/partition1/$user/*"
done
