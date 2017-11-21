function be_valid {
if [[ "$BE_PROJECT" = "" ]]
then
    echo "BE_PROJECT not set. This variable must contains your Project name"
    return 1
fi
}

function be_setup {
    if [ -f ~/.bashrc ] && [ "$(grep 'alias build-env=' ~/.bashrc)" = "" ]
    then
       echo "alias build-env='if [ -f build-env.sh ] ; then source build-env.sh ; else echo "Please move to your project where build-env.sh exists." ; fi'" >> ~/.bashrc
       echo "Alias build-env added to your existing .bashrc. Next time your could simply move to the project dir and call 'build-env'. The source task will done for you."
    fi
}

function be_ci_detected {
    export CI_ENABLED=FALSE
    if [[ "$WORKSPACE" != "" ]]
    then
        echo "Jenkins environment detected"
        export CI_WORKSPACE="$WORKSPACE"
        export CI_ENABLED=TRUE
    fi

}

function be_ci_run {
    if [[ "$CI_ENABLED" = "TRUE" ]]
    then
        set -xe
    fi

}

function be_docker_setup {
    if [ -f .be-docker ]
    then
       export BUILD_ENV_DOCKER="$(cat .be-docker)"
    else
       echo "Using docker directly. (no sudo)"
       export BUILD_ENV_DOCKER="docker"
    fi

    $BUILD_ENV_DOCKER version > /dev/null
    if [ $? -ne 0 ]
    then
       echo "$BUILD_ENV_DOCKER version fails. Check docker before going further. If you configured docker through sudo, please add --sudo:
    source build-env.sh --sudo ..."
       return 1
    fi

    $BUILD_ENV_DOCKER inspect forjj-golang-env > /dev/null
    if [ $? -ne 0 ]
    then
       bin/create-build-env.sh
    fi
}

function be_common_load {
    if [ "$BUILD_ENV_PATH" = "" ]
    then
       export BE_PROJECT
       export BUILD_ENV_LOADED=true
       export BUILD_ENV_PROJECT=$(pwd)
       BUILD_ENV_PATH=$PATH
       export PATH=$(pwd)/bin:$PATH:$GOPATH/bin
       PROMPT_ADDONS_BUILD_ENV="BE: $(basename ${BUILD_ENV_PROJECT})"
       echo "Build env loaded. To unload it, call 'build-env-unset'"
       alias build-env-unset='cd $BUILD_ENV_PROJECT && source build-unset.sh'
    fi
}

function unset_build_env {
    if [ "$BUILD_ENV_PATH" != "" ]
    then
        export PATH=$BUILD_ENV_PATH
        unset BUILD_ENV_PATH
        unset PROMPT_ADDONS_BUILD_ENV
        unset BUILD_ENV_LOADED
        unset BUILD_ENV_PROJECT
        unset BE_PROJECT
        unalias build-env-unset
        alias build-env='if [ -f build-env.sh ] ; then source build-env.sh ; else echo "Please move to your project where build-env.sh exists." ; fi'

        # TODO: Be able to load from a defined list of build env type. Here it is GO
        go_unset
    fi
}

function be-create-wrapper {
    echo "!/bin/bash
" > bin/$1
    echo "MOD=$2"
    cat $BASE_DIR/bin/pre-wrapper.sh >> bin/$1
    eval "be-create-wrapper-$1 bin/$1"
    if [[ -f $BASE_DIR/bin/post-wrapper.sh ]]
    then
        cat $BASE_DIR/bin/post-wrapper.sh >> bin/$1
    fi
    echo "$2 Wrapper '$1' created."
}

function be-create-wrapper-inenv {
    echo "# Added from $BASE_DIR/bin/inenv" >> $1
    cat $BASE_DIR/bin/inenv.sh >> $1

}

function be-create-wrappers {
    for i in ${beWrappers[@]}
    do
        be-create-wrapper bin/$i $1
    done
}

function be-update {
    if [[ ! -f build-env.sh ]] || [[ "$1" = force ]]
    then
        echo "
# Build Environment created by buildEnv
BE_PROJECT=$BE_PROJECT

# Add any module parameters here

source lib/source-build-env.sh" > build-env.sh
        echo ".build-env.sh created"
    fi

    if [[ ! -f build-env.sh ]] || [[ "$1" = force ]]
    then
        echo "
# Build Environment created by buildEnv

# unset any module parameters here

unset_build_env" > build-unset.sh
        echo ".build-env.sh created"
    fi

    if [[ "$BASE_DIR" != "" ]]
    then
        echo "$BASE_DIR" > .be-source
        echo ".be-source created."
    else
        BASE_DIR=$(cat .be-source)
        echo "Using BuildEnv from $BASE_DIR"
    fi

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

    mkdir -vp bin lib build-env-docker

    cp -v $BASE_DIR/lib/* lib/

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
}

function docker-build-env {
    source $BASE_DIR/modules/$MOD/lib/source-be-$1.sh

    be-create-wrappers $1

    if [[ "$1" != "" ]]
    then
        eval be-create-$1-docker-build
    fi
}

beWrapper=("inenv")
