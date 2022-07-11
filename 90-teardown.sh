#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

./30-main/90-destroy.sh
./20-tf-backend/90-destroy.sh
