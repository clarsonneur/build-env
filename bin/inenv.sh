# From BuildEnv bin/inenv.sh

if [[ -f $BUILD_ENV_PROJECT/build-env.modules ]]
then
    MODS=(`cat $BUILD_ENV_PROJECT/build-env.modules`)

    case ${#MODS[@]} in
    0) IMAGE=alpine ;;
    1) IMAGE="${BE_PROJECT}-${MODS[0]}-env" ;;
    *)
        for MOD in ${MODS[@]}
        do
            if [[ $MOD = $1 ]]
            then
                IMAGE="${BE_PROJECT}-$1-env"
                break
            fi
        done
        ;;
    esac
else
    IMAGE=alpine
fi

docker_run $IMAGE bash
