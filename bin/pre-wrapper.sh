# From BuildEnv bin/pre-wrapper.sh

BUILD_SCRIPT_PATH=$(dirname $0)
BUILD_SCRIPT_LIB_PATH=$(dirname $BUILD_SCRIPT_PATH)/lib

if [[ ! -f $BUILD_SCRIPT_LIB_PATH/run-build-env.sh ]]
then
    echo "Unable to load build-env.sh. '$BUILD_SCRIPT_LIB_PATH/run-build-env.sh' not found"
    exit 1
fi

source $BUILD_SCRIPT_LIB_PATH/run-build-env.sh
