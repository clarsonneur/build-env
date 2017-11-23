#!/usr/bin/env bash

# This script creates or update the build-env files
#


set -e

BASE_DIR=$(dirname $0)

if [[ "$BASE_DIR" = . ]]
then
    echo "You must go to your repository"
    exit 1
fi

source $BASE_DIR/lib/build-env.fcts.sh

if [[ "$1" = "--force" ]]
then
    FORCE=TRUE
    shift
fi

if [[ -f build-env.sh ]] && [[ "$FORCE" = "" ]]
then
   echo "Unable to create a BuildEnv on an existing one"
   exit 1
fi

if [[ $# -eq 0 ]]
then
    echo "Usage is $0 ProjectName [modules ...]
For details, go to https://github.com/forj-oss/build-env"
    exit 1
fi

BE_PROJECT=$1
shift

be-create force "$@"
be-update

echo  "Load your Build environment with build-env (alias) or source build-env.sh"

