#!/bin/bash

pdsh -w compute-0-[0-3] "poweroff"
