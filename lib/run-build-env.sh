#
# File source to provide common build functions
#

if [ "$BUILD_ENV_LOADED" != "true" ]
then
   echo "Please go to your project and load your build environment. 'source build-env.sh'"
   exit 1
fi

cd $BUILD_ENV_PROJECT

if [ "$http_proxy" != "" ]
then
   PROXY="-e http_proxy=$http_proxy -e https_proxy=$http_proxy -e no_proxy=$no_proxy"
fi

USER="-u $(id -u)"
echo "INFO! Run from docker container."

if [[ "$DOCKER_JENKINS_MOUNT" != "" ]]
then # Set if jenkins requires a different mount point
    MOUNT="-v $DOCKER_JENKINS_MOUNT"
else
    if [[ "$MOD" != "" ]]
    then
        eval "be-${MOD}-mount-setup"
    fi
fi

if [ -t 1 ]
then
   TTY="-t"
fi

function docker_run {
    if [[ "$MOD" != "" ]]
    then
        eval be_do_${MOD}_docker_run "$@"
    else
        do_docker_run "$@"
    fi
}

function do_docker_run {
    eval $BUILD_ENV_DOCKER run --rm -i $TTY $MOUNT $PROXY $USER "$@"
}
