
set -e

if [ "$BUILD_ENV_LOADED" != "true" ]
then
   echo "Please go to your project and load your build environment. 'source build-env.sh'"
   exit 1
fi

cd $BUILD_ENV_PROJECT

BUILD_ENV=${BE_PROJECT}-$MOD-env

if [ "$http_proxy" != "" ]
then
   PROXY="--build-arg http_proxy --build-arg https_proxy --build-arg no_proxy"
fi

USER="--build-arg UID=$(id -u) --build-arg GID=$(id -g)"

echo "Running Go image builder."
_be_set_debug
$BUILD_ENV_DOCKER build -q -t $BUILD_ENV $PROXY $USER build-env-docker/glide
_be_restore_debug

echo "'$BUILD_ENV' image built."

