#!/bin/bash
#
# Check that the health endpoint is returning 200 using docker

# Build image
docker build -t todo .
error=$?
if [[ $error -ne 0 ]]; then
    echo "Failed to build docker image"
    exit 1
fi

# Run image
docker_container=$(docker run --rm -d -p 6400:6400 todo)
error=$?
pid=$!
if [[ $error -ne 0 ]]; then
    echo "Failed to run docker image"
    exit 1
fi

# Wait for the container to start
sleep 10

# Check that the health endpoint is returning 200
curl -s -o /dev/null -w "%{http_code}" http://localhost:6400/api/v1/health | grep 200
error=$?
if [[ $error -ne 0 ]]; then
    echo "Failed to get 200 from health endpoint"
    exit 1
fi

# Kill docker conainer
docker stop ${docker_container}

