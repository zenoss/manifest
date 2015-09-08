#!/bin/sh
#
# Outputs a list of zenpack versions sorted in alphabetical order by zenpack name.
# This script assumes a working zendev environment and that a "zendev restore develop"
# has reset all of the zenpack repos to their 'master' branch such that the VERSION
# values in setup.py represent the latest GA version.
#
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd ${DIR}/../src
find enterprise_zenpacks zenpacks -name setup.py | xargs grep ^VERSION | cut -d/ -f2-99 | sed -e 's/\/setup.py\:/ /' | sort
