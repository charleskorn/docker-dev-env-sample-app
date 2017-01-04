# Docker development environment sample app

This is a sample application that demonstrates using Docker to containerise your development environment.

## Prerequisites

* **Docker** (Should work fine with any recent version of Docker, I've tested this with Docker for Mac version 1.13.0-rc4-beta34.1)

Note that this won't work in its current state on **Windows** as it uses a Bash shell script. 
If the shell script was translated to something that runs on Windows there should be no problems.

## Usage

### Initial / first time setup

Nothing to do - everything will be downloaded when you run the build for the first time.

### Building

Run `./build.sh`. This will compile, test and package the application, which will be placed in 
`build/libs/docker-dev-env-sample-app.jar`.

If any required components are missing or out-of-date, they'll be updated automatically.

If you want to run a different task, you can override the command used. For example, to just compile 
and test the app without packaging, run `./build.sh ./gradlew build`. 

## Modifying the build environment

The build runs in a Docker container based on the Dockerfile in the `dev-env` folder. 
(This is the magic that `build.sh` is doing in the background for you.) If you want to 
change something about the build environment (eg. upgrade Java or add a new tool), modify the
Dockerfile as necessary and subsequent builds will pick up the changes automatically.
