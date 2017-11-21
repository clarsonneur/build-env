if [[ "$CGO_ENABLED" = "0" ]]
then
   GOBIN="/usr/local/go/bin/go-static"
else
   GOBIN="/usr/local/go/bin/go"
fi

if [[ "$1" = "build" ]] || [[ "$1" = "install" ]]
then
   BUILD_BRANCH=$(git rev-parse --abbrev-ref HEAD)
   BUILD_COMMIT=$(git log --format="%H" -1)
   BUILD_DATE="$(git log --format="%ai" -1 | sed 's/ /_/g')"
   GIT_TAG="$(git tag -l --points-at HEAD)"
   if [[ "$GIT_TAG" = "" ]] || [[ "$GIT_TAG" = "latest" ]]
   then
      BUILD_TAG=false
   else
      BUILD_TAG=true
   fi
   BUILD_FLAGS="$1 -ldflags '-X main.build_branch=$BUILD_BRANCH -X main.build_commit=$BUILD_COMMIT -X main.build_date=$BUILD_DATE -X main.build_tag=$BUILD_TAG'"
   shift
fi

do_docker_run $BE_PROJECT-go-env $GOBIN $BUILD_FLAGS "$@"