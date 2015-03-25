#!/bin/bash
#
# Runs the docker container in which cucumber executes.
# See usage statement below for more details
#
# NOTE: To pass options to cucumber, you must set the CUCUMBER_OPTS
#       environment variable. For example,
#       $ CUCUMBER_OPTS="--name MyFeature" ./dockerRun.sh
#

#
# Set defaults
#
debug=false
runAsRoot=false
DRIVER_NAME=selenium
TIMEOUT=10

while (( "$#" )); do
	if [ "$1" == "-d" ]; then
		DRIVER_NAME="${2}"
		shift 2
	elif [ "$1" == "-t" ]; then
		TIMEOUT="${2}"
		shift 2
	elif [ "$1" == "--root" ]; then
		runAsRoot=true
		shift 1
	elif [ "$1" == "--debug" ]; then
		debug=true
		shift 1
	else
		if [ "$1" != "-h" ]; then
			echo "ERROR: invalid argument '$1'"
		fi
		echo "USAGE: dockerRun.sh [-d driverName] [-t timeout] [-D] [-h]"
		echo ""
		echo "where"
		echo "    -d driverName   identifies the Capybara driver to use"
		echo "                    (e.g. selenium, selenium_chrome or poltergeist)"
		echo "    -t timeout      identifies the Capybara timeout to use (in seconds)"
		echo "    --root          run the tests as root in the docker container"
		echo "    --debug         debug mode. Starts a bash shell with all of the same"
		echo "                    env vars but doesn't run anything"
		echo "    -h              print this usage statement and exit"
		exit 1
	fi

done

CALLER_UID=`id -u`
CALLER_GID=`id -g`

if [ -z "${DRIVER_NAME-}" ]; then
    DRIVER_NAME=selenium
fi

if [ -z "${CAPYBARA_TIMEOUT-}" ]; then
    CAPYBARA_TIMEOUT=10
fi

if [ "$debug" == true ]; then
	INTERACTIVE_OPTION="-i"
	CMD="bash"
elif [ "$runAsRoot" == true ]; then
	CMD="runCucumber.sh --root ${CUCUMBER_OPTS}"
else
	CMD="runCucumber.sh ${CUCUMBER_OPTS}"
fi

docker run --rm --name capybara_demo \
    -v `pwd`/demo:/capybara:rw \
    -e CALLER_UID=${CALLER_UID} \
    -e CALLER_GID=${CALLER_GID} \
    -e CAPYBARA_DRIVER=${DRIVER_NAME} \
    -e CAPYBARA_TIMEOUT=${TIMEOUT} \
    ${INTERACTIVE_OPTION} \
    -t capybara_demo \
    ${CMD}
