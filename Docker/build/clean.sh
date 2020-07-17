#!/bin/bash

# teardown all of the docker containers
docker rm -f $(docker ps -a -q) || true





echo "Done with clean!"
