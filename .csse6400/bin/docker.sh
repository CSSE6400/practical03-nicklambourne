#!/bin/bash
#
# Check that the health endpoint is returning 200 using docker

set -euo pipefail

docker ps -q | xargs -r docker kill

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
if [[ $error -ne 0 ]]; then
    echo "Failed to run docker image"
    exit 1
  else
    echo "Ran container ${docker_container}"
fi

# Wait for the container to start
echo "Sleeping for 10s"
sleep 15

# Check that the health endpoint is returning 200
curl -s -o /dev/null -w "%{http_code}" http://localhost:6400/api/v1/health | grep 200
error=$?
if [[ $error -ne 0 ]]; then
    echo "Failed to get 200 from health endpoint"
    exit 1
  else
    echo "Successfully checked health"
fi

# Kill docker conainer
docker ps -q | xargs -r docker kill

