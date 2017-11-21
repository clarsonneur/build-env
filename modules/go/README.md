# BuildEnv GO Module

To add this module to your repository,
- add `go` in your `build-env.modules`
or
- create your new build-env with
 `configure-build-env.sh <project> go`

# Parameters

## CGO_ENABLED

By default, GO creates binaries with linux library dependencies.
If you want to generate complete static files, set:

export CGO_ENABLED=0 at the beginning of your `build-env.sh`
