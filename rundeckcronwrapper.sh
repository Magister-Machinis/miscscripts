#!/bin/bash
oldscript=$(< ~/scripts/runnernumber)
kill $oldscript
pgrep -f java -jar ~/rundeck/rundeck-launcher-2.9.1.jar > ~/scripts/decknumber
kill $(< ~/scripts/decknumber)
~/scripts/rundeckrunner.sh &
$! > ~/scripts/runnernumber
