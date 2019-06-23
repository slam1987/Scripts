#!/bin/bash

if [[ $1 == "" ]] ; then
  echo "
Please enter a PID argument for the signal used
Example: signal.sh <PID> <SIGNAL ID>
"
elif [[ $2 == "" ]] ; then
  echo "
Please enter a SIGNAL ID argument with the process ID
Example: signal.sh <PID> <SIGNAL ID>
"
elif [[ $1 == "1" ]] ; then
  echo "
Send kill signal 1 for process number $2
"
  kill -s 1 $2
elif [[ $1 == "2" ]] ; then
  echo "
Send kill signal 2 for process number $2
"
  kill -s 2 $2
elif [[ $1 == "15" ]] ; then
  echo "
Send kill signal 15 for process number $2
"
  kill -s 15 $2
elif [[ $1 == "30" ]] ; then
  echo "
Send kill signal 30 for process number $2
"
  kill -s 30 $2
else
  echo "
Please enter a valid kill signal:
1 - SIGHUP
2 - SIGINT
15 - SIGTERM
30 - SIGUSR1
"
fi
