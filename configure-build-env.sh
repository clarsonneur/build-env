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

if [[ -f build-env.sh ]]
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

be-update force

echo "# Build Environment created by $(basename $0)
BE_PROJECT=$BE_PROJECT

# Add any module parameters here

source lib/source-build-env.sh
" > build-env.sh
echo ".build-env.sh created"

echo "$BASE_DIR" > .be-source
echo ".be-source created."

if [[ -d .git ]]
then
    if [[ -f .gitignore ]]
    then
        if [[ "$(cat .gitignore | grep -e "^.be-\*$")" = ""  ]]
        then
            echo ".be-*" >> .gitignore
            echo ".gitignore updated"
        fi
    else
        echo ".gitignore created"
    fi
fi

mkdir -v bin lib build-env-docker

cp -v $BASE_DIR/lib/*.sh lib/

if [[ $# -gt 0 ]]
then
    echo "" > build-env.modules
    for MOD in $*
    do
        if [[ -d $BASE_DIR/modules/$MOD ]]
        then
            cp -v $BASE_DIR/modules/$MOD/lib/*.sh lib/
            echo "$MOD" >> build-env.modules
            docker-build-env $MOD
            echo "Module $MOD added."
        fi
    done
    echo "build-env.modules created"
else
    docker-build-env
fi

