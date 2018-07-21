# From BuildEnv:modules/go/bin/glide.sh

GOPATH=$(cd $GOPATH ; pwd)

if [[ "$(echo $@ | grep $GOPATH)" != "" ]] 
then
    printf "\e[1mbuild-env INFO!\e[0m Replacing $GOPATH by /go in 'docker run'.\n"
fi
eval "$(echo docker_run ${BE_PROJECT}-go-env /usr/bin/glide "$@" | sed 's|'$GOPATH'|/go|g')"
