#!/bin/bash
runner=$!
java -jar ~/rundeck/rundeck-launcher-2.9.1.jar &
rundeckpid=$!
sleep 5m
until [ 2 -lt 1 ]; do
	pgrep -f "java -jar ~/rundeck/rundeck-launcher-2.9.1.jar" > ~/scripts/decknumber
	if [ "$(< ~/scripts/decknumber)" != "$rundeckpid" ]; then
		java -jar ~/rundeck/rundeck-launcher-2.9.1.jar &
		rundeckpid=$!
	fi
	sleep 5m
done
