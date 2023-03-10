#!/bin/bash
#
# Check that the health endpoint is returning 200 using docker-compose

set -euo pipefail

docker ps -q | xargs -r docker kill

docker-compose build
docker-compose up -d
error=$?
if [[ $error -ne 0 ]]; then
    echo "Failed to run docker-compose up"
    exit 1
fi

# Wait for the container to start
sleep 15

# Check that the health endpoint is returning 200
curl -s -o /dev/null -w "%{http_code}" http://localhost:6400/api/v1/health | grep 200
error=$?
if [[ $error -ne 0 ]]; then
    echo "Failed to get 200 from health endpoint"
    exit 1
fi

docker-compose down

docker ps -q | xargs -r docker kill
