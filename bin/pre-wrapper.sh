# From BuildEnv bin/pre-wrapper.sh

BUILD_SCRIPT_PATH=$(dirname $0)
BUILD_SCRIPT_LIB=$(dirname $BUILD_SCRIPT_PATH)/lib/run-build-env.sh

if [[ ! -f $BUILD_SCRIPT_LIB ]]
then
    echo "Unable to load build-env.sh. '$BUILD_SCRIPT_LIB' not found"
    exit 1
fi

source $BUILD_SCRIPT_LIB
