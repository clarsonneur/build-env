# Docker publish module

This build env module helps to create/build and publish a docker image to docker hub

It creates few scripts which will take the local Dockerfile image generated and
thanks to a release.lst file will publish multiple images to public Docker hub.

## Installation

To add this module to your repository:

- add `go` in your `build-env.modules`

or

- create your new build-env with
  `configure-build-env.sh <project> go`

## Parameters

None