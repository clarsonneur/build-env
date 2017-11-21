
function go_jenkins_context {
    return
}

function go_check_and_set {
    if [[ "$CI_ENABLED" = "TRUE" ]]
    then # The CI will configure the GOPATH automatically at docker call.
        return
    fi

    # Local setup
    if [[ $# -ne 0 ]]
    then
       if [[ ! -d $1 ]]
       then
          echo "Invalid gopath"
          return 1
       fi
       if [[ ! -d $1/src ]]
       then
          echo "At least, your GOPATH must have an src directory. Not found."
          return 1
       fi
       echo "$1" > .be-gopath
       echo "$1 added as GOPATH"
    fi

    if [[ -f .be-gopath ]]
    then
       gopath="$(cat .be-gopath)"
       if [[ "$gopath" != "" ]] && [[ -d "$gopath" ]]
       then
          BUILD_ENV_GOPATH="$GOPATH"
          export GOPATH="$gopath"
          echo "Local setting of GOPATH to '$GOPATH'"
       else
          echo "GOPATH = '$gopath' is invalid. Please update your .be-gopath"
       fi
    fi

    if [[ "$GOPATH" = "" ]]
    then
       echo "Missing GOPATH. Please set it, or define it in your local personal '.be-gopath' file"
       return
    fi

}

function go_unset {
    if [[ "$BUILD_ENV_GOPATH" != "" ]]
    then
      GOPATH="$BUILD_ENV_GOPATH"
      unset BUILD_ENV_GOPATH
    fi
}

function be-create-wrapper-go {
    cat $BASE_DIR/modules/go/bin/go.sh >> $1
}

function be-create-wrapper-glide {
    cat $BASE_DIR/modules/go/bin/glide.sh >> $1
}

function be-go-mount-setup {
    MOUNT="-v $GOPATH:/go -w /go/src/$BE_PROJECT"
}

function be_do_go_docker_run {
    if [[ "$CI_WORKSPACE" != "" ]]
    then # Jenkins workspace detected.
        START_DOCKER="$BUILD_ENV_DOCKER run -di $MOUNT $PROXY -e GOPATH=/go/workspace $USER $1"
        echo "Starting container : '$START_DOCKER'"
        CONT_ID=$($START_DOCKER /bin/cat)
        shift
        if [[ $CONT_ID = "" ]]
        then
            echo "Unable to start the container"
            exit 1
        fi
        set -xe
        $BUILD_ENV_DOCKER exec -i $CONT_ID mkdir -p $WORKSPACE/go-workspace/src $WORKSPACE/go-workspace/bin
        $BUILD_ENV_DOCKER exec -i $CONT_ID ln -sf $WORKSPACE/go-workspace /go/workspace
        $BUILD_ENV_DOCKER exec -i $CONT_ID ln -sf $WORKSPACE /go/workspace/src/$BE_PROJECT
        $BUILD_ENV_DOCKER exec -i $CONT_ID bash -c "cd /go/workspace/src/$BE_PROJECT ; $*"
        $BUILD_ENV_DOCKER rm -f $CONT_ID
        set +x
    else
        do_docker_run "$@"
    fi

}

beWrappers=("${beWrappers[@]}" "go go" "glide go")
