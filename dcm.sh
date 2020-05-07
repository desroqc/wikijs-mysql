#! /bin/bash
#
# DockerComposerManager v1.2.5
# DesroQC @ https://github.com/desroqc
#
# Tested with Ubuntu 18.04.4 LTS + Docker 19.03.8 + Docker-compose 1.25.0
# Docker-compose file format 3.7
#

# Variables
composer=docker-compose.yml

# Build the image from a local dockerfile
function build {
    echo "Info: Building images"
    docker-compose -f $composer build
}

# Help
function help {
    echo "-> Usage: ./dcm.sh build|help|restart|start|stop|update"
    exit
}

# Pull the image from Dockerhub
function pull {
    echo "Info: Pulling images from Dockerhub"
    docker-compose -f $composer pull
}

# Start the containers
function start {
    echo "Info: Starting containers"
    docker-compose -f $composer up -d
}

# Stop the containers
function stop {
    echo "Info: Stopping and removing containers"
    docker-compose -f $composer down
}

# Need at least 1 arguments
if [ $# -eq 0 ]; then
    echo "!Error: No argument"
    help
fi

# Actions
if [[ "$1" == "build" ]]; then
    if [ -f "./build/dockerfile" ]; then
        build
    else
        echo "!Error: No custom dockerfile inside ./build"
        exit
    fi
elif [[ "$1" == "help" ]]; then
    help
elif [[ "$1" == "start" || "$1" == "restart" ]]; then
    stop
    start
elif [[ "$1" == "stop" ]]; then
    stop
elif [[ "$1" == "update" ]]; then
    stop
    if [ -f "./build/dockerfile" ]; then
        build
    else
        pull
    fi
    start
else
    echo "!Error: Invalid action"
    help
fi

# Bye
echo "Info: Done"