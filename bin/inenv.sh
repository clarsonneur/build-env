# From BuildEnv bin/inenv.sh

if [[ "$1" == --help ]]
then
    echo "usage is inenv [module]

inenv is used to enter in the builder module container with bash to get build context."
    exit
fi

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
