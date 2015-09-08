#!/bin/sh
#
# Outputs a sorted list of repos that use the specified branch of tag namegrep
#
if [ $# -ne 1 ]; then
    echo "ERROR: incorrect number of arguments"
    echo "USAGE: $0 --platform|--solution"
    exit 1
fi

while (( "$#" )); do
    if [ "$1" == "--platform" ]; then
        platform=true
        shift 1
    elif [ "$1" == "--solution" ]; then
        platform=false
        shift 1
    else
        echo "ERROR: '$1' is an invalid argument"
        echo "USAGE: $0 --platform|--solution"
        exit 1
    fi
done

BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/' `
if [ $BRANCH == "develop" ]; then
    PLATFORM="\"ref\"\:\s\"develop"
    SOLUTION="\"ref\"\:\s\"master"
else
    PLATFORM="\"ref\"\:\s\"support/"
    SOLUTION="\"ref\"\:\s\"[0-9]"
fi

if [ "$platform" == true ]; then
    TARGET=${PLATFORM}
else
    TARGET=${SOLUTION}
fi

grep -B 1 ${TARGET} manifest.json | grep repo | sort
