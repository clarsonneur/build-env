#!/usr/bin/env bash

# This script creates or update the build-env files
#

BASE_DIR=$(dirname $0)

if [[ "$BASE_DIR" = . ]]
then
    echo "You must go to your repository"
    exit 1
fi

if [[ -f build-env.sh ]]
then
   echo "Unable to create a BuildEnv on an existing one"
   exit 1
fi


