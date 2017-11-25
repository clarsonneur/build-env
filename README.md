# Introduction

When you develop a project, it can be really important to ensure
the CI system and developers uses the same collection of tools to
build.

`Building` are one of the common task used by CI systems and Developers.
But usually, CI systems do not use the same tools version and/or
configuration that developer uses.

Build env tries resolve this gap.

## Build env core functionality

Build env provides :
- a collection of wrappers depending on modules to build
- core functionality
- creation and update of build-env

Currently, BuildEnv is ready to work in a Jenkins Context.
If you need others CI, think to contribute.

It works both with docker or sudo docker.

## Maintain build env functionality

Each source repository using build-env has a copy of build core files
in the repo.

When a fix or enhancement is needed, you should do it in this build-env
repository.

But your repository managed with build-env is not connected to this
repository.
So, to get those fixes and enhancement, build-env has an `be_update`

This one will refresh your build-env core files and wrappers from the
source repository, ie this current one.

## Modules

Core files deliver the framework. And build-env modules deliver wrappers
and functionality.

Those modules are stored under lib/* as subdirectory.

The core module delivered is GO.
It creates GO and glide wrappers, and a docker image.

## Build env installation/update feature

When *you install* a new Build env in your repository, the following files
will be created or copied:

 files                   | comments               | origin    | owner
-------------------------|------------------------|-----------|---------
 lib/source-build-env.sh | Source core file       | Copied    | BuildEnv
 lib/run-build-env.sh    | wrapper core file      | Copied    | BuildEnv
 lib/source-be-\*.sh     | Source module file     | Copied    | BuildEnv
 lib/run-be-\*.sh        | Wrapper module file    | Copied    | BuildEnv
 .be-source              | Path to BuildEnv source| created   | Your repo
 build-env.modules       | Modules list applied   | created   | Your repo
 build-env.sh            | build-env set file     | created   | Your repo
 build-unset.sh          | build-env unset file   | created   | Your repo
 build-env               | Docker image dir       | created   | Your repo
 bin/inenv               | build tool container   | Generated | BuildEnv
 bin/\*                  | wrapper files          | Generated | BuildEnv

When *you update* an existing Build env in your repository, only copied/
generated are going to be refreshed.

# Getting started

To install the build env on a new project, run:

```bash
git clone https://github.com/forj-oss/build-env <BuildEnvRepo>
cd <MyRepo>
<BuildEnvRepo>/configure-build-env.sh <project> [modules]
```

- `[modules]` is an optional list of build env modules.

    Existing modules are stored as sub directory under `lib`

    Ex: lib/go => module GO

- `<project>` is your project name and is required.

Every files are going to be generated for you.

# Updating BuildEnv from BuildEnv repository

*Warning!*

> You need to have a clone of the https://github.com/forj-oss/build-env
> repository and your `.be-source` to have the path to your build-env cloned.

> If you have installed BuildEnv with configure-build-env.sh, `.be-source`
> has been set for you.

1. load your build env with `build-env` or `source build-env.sh`
2. refresh it with `be_update`

# Updating your Project name

Edit `build-env.sh` and update `BE_PROJECT`

# Updating Modules parameters

According to the Support module parameters, edit `build-env.sh` and set
any variables before the last `source` command.
